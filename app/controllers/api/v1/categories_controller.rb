class Api::V1::CategoriesController < ApplicationController
	def index
      categories = Category.select('id,name').all
      render :json => categories
	end
end