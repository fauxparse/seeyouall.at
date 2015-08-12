class Location < ActiveRecord::Base
  # no :dependent because scheduled_activity.location can be nil
  has_many :scheduled_activities, inverse_of: :location, autosave: true
  belongs_to :event, inverse_of: :locations

  geocoded_by :address

  before_validation :geocode, if: [:address?, :address_changed?]
  validates :address, :latitude, :longitude,
    presence: { allow_blank: false }

  before_destroy :nullify_scheduled_activity_location_ids

  protected

  def nullify_scheduled_activity_location_ids
    scheduled_activities.update_all(location_id: nil)
  end
end
