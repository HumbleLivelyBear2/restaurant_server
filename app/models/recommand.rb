class Recommand < ActiveRecord::Base
  attr_accessible :area_id, :grade_food, :grade_service, :name
  belongs_to :area
end
