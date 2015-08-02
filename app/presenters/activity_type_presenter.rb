class ActivityTypePresenter < SimpleDelegator
  alias_method :activity_type, :__getobj__

  def to_s
    name
  end

  def plural
    name.pluralize
  end
end
