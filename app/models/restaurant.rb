class Restaurant < ActiveRecord::Base
  belongs_to :area
  # belongs_to :category
  has_many :note
  has_many :restaurant_category_ships
  has_many :categories, :through => :restaurant_category_ships

  has_many :restaurant_type_ships
  has_many :types, :through => :restaurant_type_ships

  scope :index_select, select("id,name,grade_food,grade_service,pic_url")
end
