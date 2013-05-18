class Type < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :restaurant_type_ships
  has_many :restaurants, :through => :restaurant_type_ships
end
