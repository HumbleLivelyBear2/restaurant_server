class Note < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :restaurant 

  scope :index_select, select("title,intro,pic_url,link")
end
