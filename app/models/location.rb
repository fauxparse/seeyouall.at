class Location < ActiveRecord::Base
  geocoded_by :address

  before_validation :geocode, if: [:address?, :address_changed?]
  validates :address, :latitude, :longitude,
    presence: { allow_blank: false }
end
