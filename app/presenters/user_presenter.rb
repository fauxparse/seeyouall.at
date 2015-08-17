class UserPresenter < SimpleDelegator
  alias_method :user, :__getobj__

  def to_s
    name
  end

  def avatar
    Avatar.new(self)
  end
end
