class EventPresenter < SimpleDelegator
  alias_method :event, :__getobj__

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

  def errors
    event.errors.to_hash.tap do |errors|
      [:start_time, :end_time].each do |key|
        errors[:"#{key.to_s.sub(/time/, "date")}"] = errors.delete(key) if errors[key].present?
      end
      errors[:slug] = [errors[:slug].first] if errors[:slug].present?
    end
  end
end