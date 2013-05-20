class Api::V1::RestaurantsController < ApplicationController
	def index
      # c = Category.find(params[:category_id])
      # rs = c.restaurants
      c_id = params[:category_id];
      a_id = params[:area_id];

      if (a_id != nil && c_id != nil) 
            c = Category.find(c_id)
            rs = c.restaurants.where(:area_id => a_id)
      elsif a_id != nil 
            rs =  Restaurant.where(:area_id => a_id)
      elsif c_id != nil
            c = Category.find(c_id)
            rs = c.restaurants
      end
                        
      render :json => rs

	end
end
