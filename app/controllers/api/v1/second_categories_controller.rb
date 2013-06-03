class Api::V1::SecondCategoriesController < ApplicationController
	def index
      categories = SecondCategory.select('id,name,category_id')
      render :json => categories
	end
end
