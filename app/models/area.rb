class Area < ActiveRecord::Base
  has_many :restaurants
  has_many :recommands
end
