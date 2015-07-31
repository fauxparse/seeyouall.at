class AddAdministratorIndices < ActiveRecord::Migration
  def change
    add_index :administrators, [:event_id, :user_id]
    add_index :administrators, :user_id
  end
end
