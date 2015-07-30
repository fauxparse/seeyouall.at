class CreateSelections < ActiveRecord::Migration
  def change
    create_table :selections do |t|
      t.belongs_to :registration, null: false, foreign_key: { on_delete: :cascade }
      t.belongs_to :scheduled_activity, null: false, foreign_key: { on_delete: :cascade }
      t.timestamps null: false
    end

    add_index :selections, [:registration_id, :scheduled_activity_id], unique: true
    add_index :selections, :scheduled_activity_id
  end
end
