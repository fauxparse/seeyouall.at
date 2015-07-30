class CreateFacilitators < ActiveRecord::Migration
  def change
    create_table :facilitators do |t|
      t.belongs_to :activity, null: false, foreign_key: { on_delete: :cascade }
      t.belongs_to :user, foreign_key: { on_delete: :nullify }
      t.string :name
      t.string :email
    end
  end
end
