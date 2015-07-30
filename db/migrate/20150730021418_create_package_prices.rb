class CreatePackagePrices < ActiveRecord::Migration
  def change
    create_table :package_prices do |t|
      t.belongs_to :package, null: false, foreign_key: { on_delete: :cascade }
      t.belongs_to :price, null: false, foreign_key: { on_delete: :cascade }
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
    end

    add_index :package_prices, [:package_id, :start_time, :end_time]
  end
end
