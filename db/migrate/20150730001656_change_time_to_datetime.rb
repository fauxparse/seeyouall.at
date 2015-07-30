class ChangeTimeToDatetime < ActiveRecord::Migration
  def change
    remove_index :events, [:start_time, :end_time]
    remove_column :events, :start_time
    remove_column :events, :end_time

    change_table :events do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
    end

    add_index :events, [:start_time, :end_time]

    remove_index :time_slots, [:event_id, :start_time, :end_time]
    remove_column :time_slots, :start_time
    remove_column :time_slots, :end_time

    change_table :time_slots do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
    end

    add_index :time_slots, [:event_id, :start_time, :end_time]
  end
end
