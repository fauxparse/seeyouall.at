class Activity < ActiveRecord::Base
  belongs_to :activity_type, inverse_of: :activities
  has_many :scheduled_activities, inverse_of: :activity,
    dependent: :destroy, autosave: true

  auto_strip_attributes :name, squish: true

  validates :name, presence: { allow_blank: false }

  delegate :event, to: :activity_type
end
