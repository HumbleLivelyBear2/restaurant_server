class Api::V1::RestaurantsController < ApplicationController
	
      def index

            c_id = params[:category_id];
            a_id = params[:area_id];
            t_id = params[:type_id];

            if (t_id == nil)
                  if (a_id != nil && c_id != nil) 
                        c = Category.find(c_id)
                        rs = c.restaurants.where(:area_id => a_id).select("restaurants.id,name,grade_food,grade_service,pic_url,x_lan, y_long").paginate(:page => params[:page], :per_page => 15)
                  elsif (a_id != nil && c_id == nil) 
                        rs =  Restaurant.where(:area_id => a_id).select("id,name,x_lan,y_long")
                  elsif (c_id != nil && a_id == nil)
                        c = Category.find(c_id)
                        rs = c.restaurants.select("restaurants.id,name,grade_food,grade_service,pic_url,x_lan, y_long").paginate(:page => params[:page], :per_page => 15)
                  end
            elsif t_id !=nil
                  if (a_id != nil)
                        rs = Restaurant.joins(:restaurant_type_ships).where("area_id = #{a_id} and type_id = #{t_id}").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lan, y_long").paginate(:page => params[:page], :per_page => 15)
                  elsif a_id == nil
                        rs = Restaurant.joins(:restaurant_type_ships).where("type_id = #{t_id}").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lan, y_long").paginate(:page => params[:page], :per_page => 15)
                  end
            end                     

            render :json => rs

	end


      # def all
      #       rs = Restaurant.select("id,name,x_lan,y_long")
      #       render :json => rs
      # end

      def show
            r_id  = params[:id];
            if (r_id =="all")
                  r = Restaurant.select("id,name,x_lan,y_long")
            else
                  r = Restaurant.find(r_id)
            end
            render :json => r
      end

      def select_restaurants
            rs = Restaurant.select("id,name,grade_food,grade_service,pic_url").all.sample(15)
            render :json => rs
      end


end
