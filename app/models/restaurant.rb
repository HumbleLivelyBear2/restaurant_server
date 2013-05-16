class Restaurant < ActiveRecord::Base
  belongs_to :area
  # belongs_to :category
  has_many :note
  has_many :restaurant_category_ships
  has_many :categories, :through => :restaurant_category_ships
end
