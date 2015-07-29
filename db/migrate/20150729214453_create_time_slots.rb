class CreateTimeSlots < ActiveRecord::Migration
  def change
    create_table :time_slots do |t|
      t.belongs_to :event, foreign_key: { on_delete: :cascade }
      t.time :start_time, null: false
      t.time :end_time, null: false
    end

    add_index :time_slots, [:event_id, :start_time, :end_time]
  end
end
