class AddLimitsToScheduledActivities < ActiveRecord::Migration
  def change
    add_column :scheduled_activities, :participant_limit, :integer
  end
end
