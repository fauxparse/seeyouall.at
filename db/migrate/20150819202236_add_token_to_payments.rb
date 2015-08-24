class AddTokenToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :token, :string, null: false, index: true
  end
end
