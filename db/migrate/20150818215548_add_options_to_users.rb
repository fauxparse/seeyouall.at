class AddOptionsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.text :options, null: false, default: "{}"
    end
  end
end
