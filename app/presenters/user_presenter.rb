class UserPresenter < SimpleDelegator
  alias_method :user, :__getobj__
end
