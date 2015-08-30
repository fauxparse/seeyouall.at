class ActivityTypePresenter < SimpleDelegator
  alias_method :activity_type, :__getobj__

  def to_s
    name
  end

  def plural
    name.pluralize
  end

  def pluralize(n)
    "#{n} #{n == 1 ? name : plural}"
  end

  def self.model_name
    ActivityType.model_name
  end
end
