class CreateSelectedRestaurants < ActiveRecord::Migration
  def change
    create_table :selected_restaurants do |t|
      t.integer :restaurant_id
      t.timestamps
    end
  end
end
