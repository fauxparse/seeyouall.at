module AccountsHelper
  def logged_in_as?(user)
    current_user.id == user.id
  end
end
