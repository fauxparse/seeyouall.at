class AddSelectionsCountToScheduledActivities < ActiveRecord::Migration
  def change
    add_column :scheduled_activities, :selections_count, :integer, default: 0
  end
end
