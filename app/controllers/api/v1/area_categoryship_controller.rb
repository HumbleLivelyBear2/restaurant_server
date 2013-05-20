class Api::V1::AreaCategoryshipController < ApplicationController
  def index
    ships = AreaCategoryship.select("area_id,category_id")
    render :json => ships
  end
end
