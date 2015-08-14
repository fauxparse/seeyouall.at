class ScheduledActivity < ActiveRecord::Base
  belongs_to :activity, inverse_of: :scheduled_activities
  belongs_to :time_slot, inverse_of: :scheduled_activities
  belongs_to :room, inverse_of: :scheduled_activities
  has_many :selections, inverse_of: :scheduled_activity, dependent: :destroy

  validates :participant_limit,
    numericality: { only_integer: true, greater_than: 0 },
    if: :limited?

  def limited?
    participant_limit?
  end

  def sold_out?
    limited? && (selections_count >= participant_limit)
  end
end
