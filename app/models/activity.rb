class Activity < ActiveRecord::Base
  belongs_to :activity_type, inverse_of: :activities
  has_many :scheduled_activities, inverse_of: :activity, autosave: true,
    dependent: :destroy
  has_many :facilitators, inverse_of: :activity, autosave: true,
    dependent: :destroy

  auto_strip_attributes :name, squish: true

  validates :name, presence: { allow_blank: false }

  delegate :event, to: :activity_type
end
