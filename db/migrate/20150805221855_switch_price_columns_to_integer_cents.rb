class SwitchPriceColumnsToIntegerCents < ActiveRecord::Migration
  def change
    remove_column :prices, :price
    add_monetize :prices, :price

    remove_column :payments, :amount
    add_monetize :payments, :amount
  end
end
