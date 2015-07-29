class TimeSlot < ActiveRecord::Base
  belongs_to :event, inverse_of: :time_slots

  validates :start_time, :end_time, presence: true
  validate :end_time_is_not_before_start_time,
    if: [ :start_time, :end_time ]

  private

  def end_time_is_not_before_start_time
    errors.add(:end_time, "can't be before start time") unless end_time >= start_time
  end
end
