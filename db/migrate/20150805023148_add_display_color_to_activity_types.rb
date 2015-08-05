class AddDisplayColorToActivityTypes < ActiveRecord::Migration
  def change
    change_table :activity_types do |t|
      t.string :color_name
    end
  end
end
