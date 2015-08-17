class CreatePaymentMethodConfigurations < ActiveRecord::Migration
  def change
    create_table :payment_method_configurations do |t|
      t.references :event, foreign_key: { on_delete: :cascade }
      t.string :payment_method_name, null: false
      t.string :options, default: "{}"
      t.boolean :enabled, null: false, default: false
    end

    add_index :payment_method_configurations, [:event_id, :payment_method_name],
      name: "index_payment_configurations_by_event_and_name"
  end
end
