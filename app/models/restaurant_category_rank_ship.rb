class RestaurantCategoryRankShip < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :rank_category_id, :restaurant_id, :area_id
  belongs_to :restaurant
  belongs_to :category
end
