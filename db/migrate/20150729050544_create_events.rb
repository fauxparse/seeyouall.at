class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.timestamps null: false
    end

    add_index :events, :slug, unique: true
  end
end
