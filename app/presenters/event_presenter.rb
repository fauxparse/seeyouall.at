class EventPresenter < SimpleDelegator
  alias_method :event, :__getobj__

  def to_s
    name
  end

  def name
    event.name || I18n.t("events.default_name")
  end

  def slug
    event.slug || name.to_url
  end

  def start_date
    (event.start_time || Time.current).to_date
  end

  def end_date
    (event.end_time || start_date + 1.week).to_date
  end

  def dates
    start_date..end_date
  end

  def time_slots
    event.time_slots.sort_by(&:start_time).map { |t| TimeSlotPresenter.new(t) }
  end

  def activity_types
    event.activity_types.map { |t| ActivityTypePresenter.new(t) }
  end

  def errors
    event.errors.to_hash.tap do |errors|
      [:start_time, :end_time].each do |key|
        errors[:"#{key.to_s.sub(/time/, "date")}"] = errors.delete(key) if errors[key].present?
      end
      errors[:slug] = [errors[:slug].first] if errors[:slug].present?
    end
  end

  def payment_methods
    @payment_methods ||= event.payment_method_configurations.select(&:enabled?)
      .map(&:payment_method)
  end

  def photo_url
    event_photos.first.try(:url)
  end

  def registration_for(user)
    registrations.detect { |r| r.user_id == user.try(:id) }
  end
end
