class CreateActivityTypes < ActiveRecord::Migration
  def change
    create_table :activity_types do |t|
      t.belongs_to :event, null: false, foreign_key: { on_delete: :cascade }
      t.string :name, null: false
    end

    add_index :activity_types, :event_id
  end
end
