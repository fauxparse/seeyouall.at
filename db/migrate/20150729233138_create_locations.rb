class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :address
      t.decimal :latitude, precision: 9, scale: 6
      t.decimal :longitude, precision: 9, scale: 6
    end

    add_index :locations, [:name]
    add_index :locations, [:address]
    add_index :locations, [:latitude, :longitude]
  end
end
