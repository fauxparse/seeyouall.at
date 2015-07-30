class CreateIndividualActivityPrices < ActiveRecord::Migration
  def change
    create_table :individual_activity_prices do |t|
      t.belongs_to :allocation, null: false, foreign_key: { on_delete: :cascade }
      t.belongs_to :price, null: false, foreign_key: { on_delete: :cascade }
    end

    add_index :individual_activity_prices, :allocation_id
  end
end
