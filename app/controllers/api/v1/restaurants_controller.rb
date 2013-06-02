class Api::V1::RestaurantsController < ApplicationController
	
      def index

            a_id   = params[:area_id];
            c_id   = params[:category_id];            
            t_id   = params[:type_id];
            r_c_id = params[:rank_category_id]

            if a_id !=nil && c_id == nil && t_id == nil && r_c_id == nil
                rs =  Restaurant.where(:area_id => a_id).select("id,name,x_lat,y_long")
            elsif  a_id ==nil && c_id != nil && t_id == nil && r_c_id == nil
                rs = Restaurant.where(:category_id=> c_id).select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long").paginate(:page => params[:page], :per_page => 15)
            elsif  a_id ==nil && c_id == nil && t_id != nil && r_c_id == nil
                type =  Type.find(t_id)
                rs = type.restaurants.select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long").paginate(:page => params[:page], :per_page => 15)
            elsif a_id ==nil && c_id == nil && t_id == nil && r_c_id != nil
                rc = RankCategory.find(r_c_id)
                rs = rc.restaurants.select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long").paginate(:page => params[:page], :per_page => 15)
            elsif a_id !=nil && c_id != nil && t_id == nil && r_c_id == nil
                rs = Restaurant.where(:category_id => c_id, :area_id => a_id).select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long").paginate(:page => params[:page], :per_page => 15)
            elsif a_id !=nil && c_id == nil && t_id != nil && r_c_id == nil
                rs_ids = RestaurantTypeShip.where("area_id= #{a_id} and type_id = #{t_id}").select("restaurant_id")
                rs = Restaurant.where(id:rs_ids).select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long").paginate(:page => params[:page], :per_page => 15)
                # type =  Type.find(t_id)
                # rs = type.restaurants.where(:area_id => a_id).select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long").paginate(:page => params[:page], :per_page => 15)
            elsif a_id !=nil && c_id == nil && t_id == nil && r_c_id != nil
                rs_ids = RestaurantCategoryRankShip.where("area_id= #{a_id} and rank_category_id = #{r_c_id}").select("restaurant_id")
                rs = Restaurant.where(id:rs_ids).select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long").paginate(:page => params[:page], :per_page => 15)
                # rc = RankCategory.find(r_c_id)
                # rs = rc.restaurants.where(:area_id => a_id).select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long").paginate(:page => params[:page], :per_page => 15)
            end                   

            render :json => rs

	end


      # def all
      #       rs = Restaurant.select("id,name,x_lat,y_long")
      #       render :json => rs
      # end

      def show
            r_id  = params[:id];
            if (r_id =="all")
                  r = Restaurant.select("id,name,x_lat,y_long")
            else
                  r = Restaurant.find(r_id)
            end
            render :json => r
      end

      def select_restaurants
            rs_ids = SelectedRestaurant.select("restaurant_id")
            rs = Restaurant.where(id:rs_ids).select("id,name,grade_food,grade_service,pic_url").paginate(:page => params[:page], :per_page => 15)
            render :json => rs
      end


end
