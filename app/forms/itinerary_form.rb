class ItineraryForm
  include ::ActiveModel::Validations

  validate :enforce_package_limits
  validate :restrict_clashes

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

      schedules.map.with_object(status) do |selected, hash|
        hash[selected.id] << :selected
        event.scheduled_activities.each do |schedule|
          next if schedule.id == selected.id || !hash[schedule.id].include?(:available)
          if selected.time_slot.overlaps?(schedule.time_slot)
            hash[schedule.id] ^= [:available, :restricted]
          end
        end
      end
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

  def counts_by_activity_type
    @counts ||= begin
      chunked = schedules.map(&:activity).sort_by(&:activity_type_id).chunk(&:activity_type_id)
      chunked.map.with_object(Hash.new(0)) do |(id, activities), counts|
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
    selected = selections.reject(&:marked_for_destruction?)
    selected.each.with_index do |selection, i|
      selected[0...i].each do |candidate|
        if selection.time_slot.overlaps?(candidate.time_slot)
          message = I18n.t("activerecord.errors.messages.schedule_clash",
            first: candidate.activity.name,
            second: selection.activity.name
          )
          errors.add(:selections, message)
        end
      end
    end
  end
end
