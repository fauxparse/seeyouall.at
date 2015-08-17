class AddPaymentMethodToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :payment_method_name, :string, null: false, index: true
  end
end
