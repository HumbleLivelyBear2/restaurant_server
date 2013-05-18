class RestaurantTypeShip < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :type_id, :restaurant_id
  belongs_to :restaurant
  belongs_to :type
end
