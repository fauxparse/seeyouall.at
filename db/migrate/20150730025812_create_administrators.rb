class CreateAdministrators < ActiveRecord::Migration
  def change
    create_table :administrators do |t|
      t.belongs_to :user, null: false, foreign_key: { on_delete: :cascade }
      t.belongs_to :event, null: false, foreign_key: { on_delete: :cascade }
    end
  end
end
