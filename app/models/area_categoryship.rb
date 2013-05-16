class AreaCategoryship < ActiveRecord::Base
  attr_accessible :area_id, :category_id
  belongs_to :area;
  belongs_to :category;
end
