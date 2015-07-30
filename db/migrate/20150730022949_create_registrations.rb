class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.belongs_to :user, null: false, foreign_key: { on_delete: :cascade }
      t.belongs_to :event, null: false, foreign_key: { on_delete: :cascade }
      t.belongs_to :package, null: false, foreign_key: { on_delete: :cascade }
      t.timestamps null: false
    end

    add_index :registrations, [:user_id, :event_id]
    add_index :registrations, [:package_id, :event_id]
  end
end
