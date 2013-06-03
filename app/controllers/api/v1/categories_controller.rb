class Api::V1::CategoriesController < ApplicationController
	def index
      @categories = Category.includes(:second_categories).select('id,name').all
      # render :json => categories
	end
end
