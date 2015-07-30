class CreateAllocations < ActiveRecord::Migration
  def change
    create_table :allocations do |t|
      t.belongs_to :package, null: false, foreign_key: { on_delete: :cascade }
      t.belongs_to :activity_type, null: false, foreign_key: { on_delete: :cascade }
      t.integer :maximum
    end

    add_index :allocations, [:package_id, :activity_type_id], unique: true
  end
end
