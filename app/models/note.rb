class Note < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :restaurant 

  scope :index_select, select("id,restaurant_id,title,intro,pic_url,link")
end
