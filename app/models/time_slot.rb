class TimeSlot < ActiveRecord::Base
  belongs_to :event, inverse_of: :time_slots

  validates :start_time, :end_time, presence: true
  validates_with TimePeriodValidator
end
