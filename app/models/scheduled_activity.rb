class ScheduledActivity < ActiveRecord::Base
  belongs_to :activity, inverse_of: :scheduled_activities
  belongs_to :time_slot, inverse_of: :scheduled_activities
  belongs_to :location, inverse_of: :scheduled_activities
end
