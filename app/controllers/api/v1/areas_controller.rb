class Api::V1::AreasController < ApplicationController
	def index
      areas = Area.select('id,name').all
      render :json => areas
	end
end
