class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.decimal :price, precision: 10, scale: 2, null: false
    end
  end
end
