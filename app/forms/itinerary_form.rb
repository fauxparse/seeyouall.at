class ItineraryForm
  include ::ActiveModel::Validations

  validate :enforce_package_limits
  validate :restrict_clashes
  validate :respect_participant_limits

  def initialize(registration, params = {})
    @registration = RegistrationPresenter.new(registration)

    params.each_pair do |attr, value|
      public_send :"#{attr}=", value
    end
  end

  def event
    @event ||= EventPresenter.new(registration.event)
  end

  def package
    @package ||= PackagePresenter.new(registration.package)
  end

  def registration
    @registration
  end

  def save
    valid? && registration.save
  end

  def save!
    if valid?
      registration.save!
    else
      raise(ActiveRecord::RecordInvalid.new(self))
    end
  end

  def selections=(schedule_ids)
    schedule_ids.map!(&:to_i)

    remove_deselected_activities(schedule_ids)
    add_new_selections(schedule_ids)
  end

  def schedules
    registration.selections
      .reject(&:marked_for_destruction?)
      .map(&:scheduled_activity)
  end

  def schedule
    @schedule ||= begin
      status = registration.event.scheduled_activities.map.with_object({}) do |s, hash|
        hash[s.id] = Set.new([determine_scheduled_activity_state(s)])
      end

      add_status_information_for_selected_activities(status)
      add_status_information_for_limited_activities(status)
    end
  end

  def determine_scheduled_activity_state(scheduled_activity)
    allocation = allocation_for_activity_type(scheduled_activity.activity.activity_type_id)
    if allocation
      if allocation.unlimited?
        :unlimited
      elsif counts_by_activity_type[allocation.activity_type_id] < allocation.maximum
        :available
      else
        :limited
      end
    else
      :unavailable
    end
  end

  def scheduled_activity_state(scheduled_activity_id)
    schedule[scheduled_activity_id]
  end

  def selections
    registration.selections
  end

  def activities
    schedules.map(&:activity).sort_by(&:activity_type_id)
  end

  def counts_by_activity_type
    @counts ||= begin
      schedules_chunked_by_activity_type.map.with_object(Hash.new(0)) do |(id, activities), counts|
        counts[id] = activities.length
      end
    end
  end

  def allocation_for_activity_type(activity_type_id)
    package.allocations.detect { |a| a.activity_type_id == activity_type_id }
  end

  protected

  def remove_deselected_activities(new_ids)
    selections.each do |selection|
      selection.mark_for_destruction if new_ids.exclude?(selection.scheduled_activity_id)
    end
  end

  def add_new_selections(new_ids)
    (new_ids - selections.map(&:scheduled_activity_id)).each do |id|
      remove_clashes_with(event.scheduled_activities.find(id))
      selections.build(scheduled_activity_id: id)
    end
  end

  def remove_clashes_with(scheduled_activity)
    selections.each do |selection|
      next if selection.marked_for_destruction? #|| selection.new_record?

      if selection.scheduled_activity.time_slot.overlaps?(scheduled_activity.time_slot)
        selection.mark_for_destruction
      end
    end
  end

  def enforce_package_limits
    counts_by_activity_type.each_pair do |activity_type_id, count|
      allocation = allocation_for_activity_type(activity_type_id)
      if allocation.present?
        if !allocation.unlimited? && count > allocation.maximum
          add_too_many_error(allocation.activity_type, count, allocation.maximum)
        end
      else
        add_no_allocation_error(activity_type_id)
      end
    end
  end

  def add_too_many_error(type, count, maximum)
    message = I18n.t("activerecord.errors.messages.too_many",
      type: type.plural, count: count, maximum: maximum
    )
    errors.add(:selections, message)
  end

  def add_no_allocation_error(type_id)
    type = event.activity_types.detect { |t| t.id == type_id }
    message = I18n.t("activerecord.errors.messages.activity_type_not_allowed",
      type: type.plural
    )
    errors.add(:selections, message)
  end

  def restrict_clashes
    with_selections_for_comparison do |selection, candidate|
      if selection.time_slot.overlaps?(candidate.time_slot)
        add_restriction_error(selection, candidate)
      end
    end
  end

  def with_selections_for_comparison
    selected = selections.reject(&:marked_for_destruction?)
    selected.each.with_index do |selection, i|
      selected[0...i].each { |candidate| yield(selection, candidate) }
    end
  end

  def add_restriction_error(selection, candidate)
    message = I18n.t("activerecord.errors.messages.schedule_clash",
      first: candidate.activity.name,
      second: selection.activity.name
    )
    errors.add(:selections, message)
  end

  def add_status_information_for_selected_activities(status)
    schedules.map.with_object(status) do |selected, hash|
      hash[selected.id] << :selected
      add_clash_information(selected, hash)
    end
  end

  def add_status_information_for_limited_activities(status)
    event.scheduled_activities.select(&:sold_out?).each.with_object(status) do |scheduled, hash|
      hash[scheduled.id] << :sold_out
    end
  end

  def add_clash_information(selected, status)
    event.scheduled_activities.each do |schedule|
      next if schedule.id == selected.id || !status[schedule.id].include?(:available)
      if selected.time_slot.overlaps?(schedule.time_slot)
        status[schedule.id] ^= [:available, :restricted]
      end
    end
  end

  def schedules_chunked_by_activity_type
    activities.chunk(&:activity_type_id)
  end

  def respect_participant_limits
    registration.selections.each do |selection|
      if selection.new_record? && selection.scheduled_activity.sold_out?
        add_sold_out_error(selection.scheduled_activity)
      end
    end
  end

  def add_sold_out_error(scheduled)
    message = I18n.t("activerecord.errors.messages.sold_out", activity: scheduled.activity.name)
    errors.add(:selections, message)
  end
end
