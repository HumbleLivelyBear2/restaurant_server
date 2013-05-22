class Area < ActiveRecord::Base
  has_many :restaurants
  has_many :area_categoryships
  has_many :categories, :through => :area_categoryships

  has_many :recommands
end
