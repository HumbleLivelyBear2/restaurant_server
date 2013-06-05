class AddIntserviceAndIntFoodToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :int_service, :integer
    add_column :restaurants, :int_food, :integer
  end
end
