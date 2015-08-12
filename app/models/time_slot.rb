class TimeSlot < ActiveRecord::Base
  belongs_to :event, inverse_of: :time_slots
  has_many :scheduled_activities, inverse_of: :time_slot,
    dependent: :destroy, autosave: true

  validates :start_time, :end_time, presence: true
  validates_with TimePeriodValidator

  def empty?
    scheduled_activities.empty?
  end

  def overlaps?(another)
    start_time <= another.end_time &&
    another.start_time <= end_time
  end
end
