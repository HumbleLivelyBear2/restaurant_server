class Api::V1::RestaurantsController < ApplicationController
	
      def index

            c_id = params[:category_id];
            a_id = params[:area_id];

            if (a_id != nil && c_id != nil) 
                  c = Category.find(c_id)
                  rs = c.restaurants.where(:area_id => a_id).index_select
            elsif (a_id != nil && c_id == nil) 
                  rs =  Restaurant.where(:area_id => a_id).index_select
            elsif (c_id != nil && a_id == nil)
                  c = Category.find(c_id)
                  rs = c.restaurants.index_select
            end

            render :json => rs

	end

      def show
            r_id  = params[:id];
            r = Restaurant.find(r_id)
            render :json => r
      end
end
