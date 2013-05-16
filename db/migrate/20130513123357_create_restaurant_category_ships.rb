class CreateRestaurantCategoryShips < ActiveRecord::Migration
  def change
    create_table :restaurant_category_ships do |t|
      t.integer :restaurant_id
      t.integer :category_id

      t.timestamps
    end
  end
end
