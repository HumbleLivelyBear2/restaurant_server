class RankCategory < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :restaurant_category_rank_ships
  has_many :restaurants, :through => :restaurant_category_rank_ships
end
