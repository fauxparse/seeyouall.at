class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :url
      t.timestamps null: false
    end

    create_table :event_photos do |t|
      t.belongs_to :event, foreign_key: { on_delete: :cascade }
      t.belongs_to :photo, foreign_key: { on_delete: :cascade }
    end

    create_table :activity_photos do |t|
      t.belongs_to :activity, foreign_key: { on_delete: :cascade }
      t.belongs_to :photo, foreign_key: { on_delete: :cascade }
    end
  end
end
