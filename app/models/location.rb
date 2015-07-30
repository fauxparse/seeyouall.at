class Location < ActiveRecord::Base
  # no :dependent because scheduled_activity.location can be nil
  has_many :scheduled_activities, inverse_of: :location, autosave: true

  geocoded_by :address

  before_validation :geocode, if: [:address?, :address_changed?]
  validates :address, :latitude, :longitude,
    presence: { allow_blank: false }
end
