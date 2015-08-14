class Room < ActiveRecord::Base
  # no :dependent because scheduled_activity.location can be nil
  has_many :scheduled_activities, inverse_of: :room
  belongs_to :location, inverse_of: :rooms

  before_destroy :nullify_scheduled_activity_room_ids

  protected

  def nullify_scheduled_activity_room_ids
    scheduled_activities.update_all(room_id: nil)
  end
end
