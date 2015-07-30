class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.belongs_to :registration, null: false, foreign_key: { on_delete: :cascade }
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.integer :state, null: false, default: 0
      t.string :reference
      t.timestamps null: false
    end
  end
end
