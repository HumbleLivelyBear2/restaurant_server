class SecondCategory < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :category
end
