class AddXyToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :x_lan, :decimal, :precision => 15, :scale => 10
    add_column :restaurants, :y_long, :decimal, :precision => 15, :scale => 10
  end
end
