class User < ActiveRecord::Base
  serialize :looked_restaurants
  serialize :looked_notes
end
