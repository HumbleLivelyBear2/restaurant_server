class Api::V1::RestaurantsController < ApplicationController
	def index
      # c = Category.find(params[:category_id])
      # rs = c.restaurants
      c_id = params[:category_id];
      a_id = params[:area_id];

      begin
      	puts "c_id =" +c_id.to_s
      rescue Exception => e
      	puts "c_id =" +0.to_s
      end
      
      
      begin
      	puts "a_id =" +a_id.to_s
      rescue Exception => e
      	puts "a_id =" +0.to_s
      end

      c = Category.find(c_id)
      if (a_id == nil)
      	rs = c.restaurants.index_select
      else
      	rs = c.restaurants.where(:area_id => a_id).index_select
      end

      # c = Category.find(c_id )
      # rs = c.restaurants
      render :json => rs
	end
end
