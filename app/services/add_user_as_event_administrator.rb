class AddUserAsEventAdministrator < Struct.new(:user, :event)
  def call
    Administrator.create!(user: user, event: event) unless already_exists?
  end

  private

  def already_exists?
    Administrator.where(user_id: user.id, event_id: event.id).exists?
  end
end
