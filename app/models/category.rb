class Category < ActiveRecord::Base
  has_many :area_categoryships
  has_many :areas, :through => :area_categoryships

  has_many :restaurant_category_ships
  has_many :restaurants, :through => :restaurant_category_ships
end
