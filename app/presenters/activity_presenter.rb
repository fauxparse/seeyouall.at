class ActivityPresenter < SimpleDelegator
  alias_method :activity, :__getobj__

  def to_s
    name
  end
end
