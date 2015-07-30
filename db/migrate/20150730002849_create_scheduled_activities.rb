class CreateScheduledActivities < ActiveRecord::Migration
  def change
    create_table :scheduled_activities do |t|
      t.belongs_to :activity, null: false, foreign_key: { on_delete: :cascade }
      t.belongs_to :time_slot, null: false, foreign_key: { on_delete: :cascade }
      t.belongs_to :location, foreign_key: { on_delete: :nullify }
    end

    add_index :scheduled_activities, :time_slot_id
    add_index :scheduled_activities, :activity_id
    add_index :scheduled_activities, :location_id
  end
end
