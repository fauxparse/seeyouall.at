class Location < ActiveRecord::Base
  belongs_to :event, inverse_of: :locations
  has_many :rooms, inverse_of: :location, autosave: true, dependent: :destroy

  geocoded_by :address

  before_validation :geocode, if: [:address?, :address_changed?]
  validates :address, :latitude, :longitude,
    presence: { allow_blank: false }
end
