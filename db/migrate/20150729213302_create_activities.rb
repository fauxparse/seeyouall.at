class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.belongs_to :activity_type, foreign_key: { on_delete: :cascade }
      t.string :name, null: false
      t.timestamps null: false
    end

    add_index :activities, :activity_type_id
  end
end
