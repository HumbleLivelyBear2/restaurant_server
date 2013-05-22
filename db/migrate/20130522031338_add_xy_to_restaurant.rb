class AddXyToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :x_lan, :float
    add_column :restaurants, :y_long, :float
  end
end
