class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.belongs_to :event, foreign_key: { on_delete: :cascade }
    end

    add_index :packages, :event_id
  end
end
