class CreateRooms < ActiveRecord::Migration
  def up
    create_table :rooms do |t|
      t.string :name
      t.references :location, index: true, foreign_key: true
    end

    add_reference :scheduled_activities, :room, index: true, foreign_key: true
    remove_column :scheduled_activities, :location_id
  end

  def down
    add_reference :scheduled_activities, :location, index: true, foreign_key: true
    remove_column :scheduled_activities, :room_id
    drop_table :rooms
  end
end
