class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title
      t.string :author
      t.string :pic_url
      t.string :pub_date
      t.string :ipeen_link
      t.string :blog_link
      
      t.integer :restaurant_id
      t.boolean :is_show
      t.timestamps
    end
    add_index :notes, :restaurant_id
  end
end
