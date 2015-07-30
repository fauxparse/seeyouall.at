class TimeSlot < ActiveRecord::Base
  belongs_to :event, inverse_of: :time_slots
  has_many :scheduled_activities, inverse_of: :time_slot,
    dependent: :destroy, autosave: true

  validates :start_time, :end_time, presence: true
  validates_with TimePeriodValidator
end
