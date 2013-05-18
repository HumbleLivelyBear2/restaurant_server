class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string  :name
      t.string  :eztable_link
      t.string  :grade_food
      t.string  :grade_ambiance
      t.string  :grade_service
      t.string  :pic_url
      t.string  :address
      t.text    :open_time
      t.string  :official_link
      t.string  :eat_type
      t.string  :price
      t.text    :traffic
      t.text    :introduction

      t.integer :area_id
      # t.integer :category_id
      t.timestamps
    end

    add_index :restaurants, :area_id
    # add_index :restaurants, :category_id
    add_index :restaurants, :name
  end
end
