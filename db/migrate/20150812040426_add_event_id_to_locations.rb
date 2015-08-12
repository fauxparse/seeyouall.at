class AddEventIdToLocations < ActiveRecord::Migration
  def change
    add_reference :locations, :event, index: true, foreign_key: true
  end
end
