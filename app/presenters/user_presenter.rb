class UserPresenter < SimpleDelegator
  alias_method :user, :__getobj__

  def to_s
    name
  end
end
