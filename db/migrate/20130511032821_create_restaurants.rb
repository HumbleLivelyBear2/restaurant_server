class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string  :name
      t.string  :pic_url
      t.string  :ipeen_link
      t.string  :grade_food
      t.string  :grade_service
      t.string  :grade_ambiance
      
      t.string  :price     
      t.string  :open_time
      t.string  :rest_date 

      t.string  :address
      t.string  :phone
      t.integer :rate_num
      t.text    :introduction
      t.string  :official_link
      t.string  :recommand_dish

      t.decimal :x_lat,  :precision => 15, :scale => 10
      t.decimal :y_long, :precision => 15, :scale => 10

      t.integer :category_id
      t.integer :second_category_id
      t.integer :area_id

      t.boolean :is_show
      t.timestamps
    end

    add_index :restaurants, :area_id
    # add_index :restaurants, :category_id
    add_index :restaurants, :name
  end
end
