class Api::V1::CategoriesController < ApplicationController
	def index
    @categories = Category.includes(:second_categories).select('id,name').all
    # render :json => categories
	end
  def rake_categories
    @categories = RankCategory.select('id,name').all
    render :json => @categories
  end
end
