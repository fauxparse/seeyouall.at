class Activity < ActiveRecord::Base
  belongs_to :activity_type, inverse_of: :activities
  has_many :scheduled_activities, inverse_of: :activity, autosave: true,
    dependent: :destroy
  has_many :facilitators, inverse_of: :activity, autosave: true,
    dependent: :destroy
  has_many :activity_photos, inverse_of: :activity, autosave: true, dependent: :destroy

  auto_strip_attributes :name, squish: true

  validates :name, presence: { allow_blank: false }

  scope :with_photos, -> { preload(:activity_photos => :photo) }

  delegate :event, to: :activity_type
end
