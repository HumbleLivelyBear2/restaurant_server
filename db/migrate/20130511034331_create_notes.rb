class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title
      t.string :intro
      t.string :pic_url
      t.string :link
      t.integer :restaurant_id
      t.integer :area_id
      t.timestamps
    end
    add_index :notes, :restaurant_id
    add_index :notes, :area_id
  end
end
