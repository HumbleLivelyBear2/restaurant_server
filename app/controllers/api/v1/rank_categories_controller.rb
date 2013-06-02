class Api::V1::RankCategoriesController < ApplicationController
	def index
      categories = RankCategory.select('id,name').all
      render :json => categories
	end
end
