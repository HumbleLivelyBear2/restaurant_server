class Api::V1::TypesController < ApplicationController
  def index
    types = Type.select('id,name').all
    render :json => types
  end

  def type_area_ship
    ships = RestaurantTypeShip.joins(:restaurant).select("restaurants.area_id,type_id")
    render :json => ships
  end
end
