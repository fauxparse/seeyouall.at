class AddDatesToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.string :time_zone, null: false, default: Time.zone.name
    end

    add_index :events, [:start_time, :end_time]
  end
end
