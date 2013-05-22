class Api::V1::RestaurantsController < ApplicationController
	
      def index

            c_id = params[:category_id];
            a_id = params[:area_id];
            t_id = params[:type_id];

            if (t_id == nil)
                  if (a_id != nil && c_id != nil) 
                        c = Category.find(c_id)
                        rs = c.restaurants.where(:area_id => a_id).index_select.paginate(:page => params[:page], :per_page => 15)
                  elsif (a_id != nil && c_id == nil) 
                        rs =  Restaurant.where(:area_id => a_id).index_select.paginate(:page => params[:page], :per_page => 15)
                  elsif (c_id != nil && a_id == nil)
                        c = Category.find(c_id)
                        rs = c.restaurants.index_select.paginate(:page => params[:page], :per_page => 15)
                  end
            elsif t_id !=nil
                  if (a_id != nil)
                        rs = Restaurant.joins(:restaurant_type_ships).where("area_id = #{a_id} and type_id = #{t_id}").select("restaurants.id,name,grade_food,grade_service,pic_url").paginate(:page => params[:page], :per_page => 15)
                  elsif a_id == nil
                        rs = Restaurant.joins(:restaurant_type_ships).where("type_id = #{t_id}").select("restaurants.id,name,grade_food,grade_service,pic_url").paginate(:page => params[:page], :per_page => 15)
                  end
            end                     

            render :json => rs

	end

      def show
            r_id  = params[:id];
            r = Restaurant.find(r_id)
            render :json => r
      end
end
