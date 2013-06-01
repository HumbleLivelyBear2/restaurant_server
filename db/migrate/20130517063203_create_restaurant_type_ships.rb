class CreateRestaurantTypeShips < ActiveRecord::Migration
  def change
  	create_table :restaurant_type_ships do |t|
  	  t.integer :restaurant_id
      t.integer :type_id
      t.integer :area_id

  	  t.timestamps
  	end
    add_index :restaurant_type_ships, :restaurant_id
    add_index :restaurant_type_ships, :type_id
    add_index :restaurant_type_ships, :area_id
  end
end
