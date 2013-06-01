class CreateRestaurantCategoryRankShips < ActiveRecord::Migration
  def change
    create_table :restaurant_category_rank_ships do |t|
      t.integer :restaurant_id
      t.integer :rank_category_id
      t.integer :area_id

      t.timestamps
    end
    add_index :restaurant_category_rank_ships, :restaurant_id
    add_index :restaurant_category_rank_ships, :rank_category_id
    add_index :restaurant_category_rank_ships, :area_id
  end
end
