class Api::V1::AreasController < ApplicationController
	def index
      # areas = Area.select('id,name').all
      areas = Area.select('id,name').find(:all, :conditions=>["id !=?", 17])
      areas << Area.select('id,name').find(17)
      render :json => areas
	end
end
