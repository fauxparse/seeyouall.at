class ActivityType < ActiveRecord::Base
  belongs_to :event, inverse_of: :activity_types

  auto_strip_attributes :name, squish: true

  validates :name,
    presence: { allow_blank: false },
    uniqueness: { scope: :event_id }
  validates :event_id, presence: true
end
