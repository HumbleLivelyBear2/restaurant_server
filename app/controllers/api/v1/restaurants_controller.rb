class Api::V1::RestaurantsController < ApplicationController
	
      def index

            a_id   = params[:area_id];
            c_id   = params[:category_id];            
            t_id   = params[:type_id];
            r_c_id = params[:rank_category_id]
            sec_c_id = params[:sec_c_id]

            if a_id !=nil && c_id == nil && t_id == nil && r_c_id == nil && sec_c_id ==nil
                rs =  Restaurant.where(:area_id => a_id).select("id,name,x_lat,y_long")
            elsif  a_id ==nil && c_id != nil && t_id == nil && r_c_id == nil && sec_c_id ==nil
                rs = Restaurant.where(:category_id=> c_id).select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").paginate(:page => params[:page], :per_page => 16)
            elsif  a_id ==nil && c_id == nil && t_id == nil && r_c_id == nil && sec_c_id !=nil
                rs = Restaurant.where(:second_category_id=> sec_c_id).select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").paginate(:page => params[:page], :per_page => 16)
            elsif  a_id ==nil && c_id == nil && t_id != nil && r_c_id == nil && sec_c_id ==nil
                type =  Type.find(t_id)
                rs = type.restaurants.select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").paginate(:page => params[:page], :per_page => 16)
            elsif a_id ==nil && c_id == nil && t_id == nil && r_c_id != nil && sec_c_id ==nil
                rc = RankCategory.find(r_c_id)
                rs = rc.restaurants.select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").paginate(:page => params[:page], :per_page => 16)
            elsif a_id !=nil && c_id != nil && t_id == nil && r_c_id == nil && sec_c_id ==nil
                rs = Restaurant.where(:category_id => c_id, :area_id => a_id).select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").paginate(:page => params[:page], :per_page => 16)
            elsif a_id !=nil && c_id == nil && t_id == nil && r_c_id == nil && sec_c_id !=nil
                rs = Restaurant.where(:second_category_id => sec_c_id, :area_id => a_id).select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").paginate(:page => params[:page], :per_page => 16)
            elsif a_id !=nil && c_id == nil && t_id != nil && r_c_id == nil && sec_c_id ==nil
                rs_ids = RestaurantTypeShip.where("area_id= #{a_id} and type_id = #{t_id}").select("restaurant_id")
                rs = Restaurant.where(id:rs_ids).select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").paginate(:page => params[:page], :per_page => 16)
                # type =  Type.find(t_id)
                # rs = type.restaurants.where(:area_id => a_id).select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long").paginate(:page => params[:page], :per_page => 16)
            elsif a_id !=nil && c_id == nil && t_id == nil && r_c_id != nil && sec_c_id ==nil
                rs_ids = RestaurantCategoryRankShip.where("area_id= #{a_id} and rank_category_id = #{r_c_id}").select("restaurant_id")
                rs = Restaurant.where(id:rs_ids).select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").paginate(:page => params[:page], :per_page => 16)
                # rc = RankCategory.find(r_c_id)
                # rs = rc.restaurants.where(:area_id => a_id).select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long").paginate(:page => params[:page], :per_page => 16)
            end                   

            render :json => rs

      end


      def area_restaurants      
        a_id   = params[:area_id]
        price_low = params[:price_low]
        price_high = params[:price_high]
        is_service_order = params[:is_service_order]
        is_dis_order = params[:is_dis_order]
        x = params[:x].to_f
        y = params[:y].to_f

        if is_service_order == nil && is_dis_order == nil
          rs = Restaurant.where("area_id = #{a_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").paginate(:page => params[:page], :per_page => 16)
        elsif is_service_order == "true" && is_dis_order == nil
          rs = Restaurant.where("area_id = #{a_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price,rate_num").order("rate_num DESC").paginate(:page => params[:page], :per_page => 16)
        elsif is_service_order == nil && is_dis_order == "true"
          rs = Restaurant.where("area_id = #{a_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").order("(ABS(#{x}-x_lat) + ABS(#{y}-y_long)) ASC").paginate(:page => params[:page], :per_page => 16)
        end

        render :json => rs
      end

      def category_restaurants
        a_id   = params[:area_id]
        c_id   = params[:category_id]
        price_low = params[:price_low]
        price_high = params[:price_high]
        is_service_order = params[:is_service_order]
        is_dis_order = params[:is_dis_order]
        x = params[:x].to_f
        y = params[:y].to_f
        if a_id != nil
          if is_service_order == nil && is_dis_order == nil 
            rs = Restaurant.where("area_id = #{a_id} and category_id = #{c_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").paginate(:page => params[:page], :per_page => 16)
          elsif is_service_order == "true" && is_dis_order == nil
            rs = Restaurant.where("area_id = #{a_id} and category_id = #{c_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price,rate_num").order("rate_num DESC").paginate(:page => params[:page], :per_page => 16)
          elsif is_service_order == nil && is_dis_order == "true"
            rs = Restaurant.where("area_id = #{a_id} and category_id = #{c_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").order("(ABS(#{x}-x_lat) + ABS(#{y}-y_long)) ASC").paginate(:page => params[:page], :per_page => 16)
          end
        elsif a_id == nil
          if is_service_order == nil && is_dis_order == nil 
            rs = Restaurant.where("category_id = #{c_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").paginate(:page => params[:page], :per_page => 16)
          elsif is_service_order == "true" && is_dis_order == nil
            rs = Restaurant.where("category_id = #{c_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price,rate_num").order("rate_num DESC").paginate(:page => params[:page], :per_page => 16)
          elsif is_service_order == nil && is_dis_order == "true"
            rs = Restaurant.where("category_id = #{c_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").order("(ABS(#{x}-x_lat) + ABS(#{y}-y_long)) ASC").paginate(:page => params[:page], :per_page => 16)
          end
        end

        render :json => rs           
      end

      def type_restaurants
          a_id   = params[:area_id]
          t_id   = params[:type_id]
          price_low = params[:price_low]
          price_high = params[:price_high]
          is_service_order = params[:is_service_order]
          is_dis_order = params[:is_dis_order]
          x = params[:x].to_f
          y = params[:y].to_f
          if a_id != nil
            if is_service_order == nil && is_dis_order == nil
              rs = Restaurant.joins(:restaurant_type_ships).where("restaurants.area_id = #{a_id} and restaurant_type_ships.type_id = #{t_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").paginate(:page => params[:page], :per_page => 16)
            elsif is_service_order == "true" && is_dis_order == nil
              rs = Restaurant.joins(:restaurant_type_ships).where("restaurants.area_id = #{a_id} and restaurant_type_ships.type_id = #{t_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price,rate_num").order("rate_num DESC").paginate(:page => params[:page], :per_page => 16)
            elsif is_service_order == nil && is_dis_order == "true"
              rs = Restaurant.joins(:restaurant_type_ships).where("restaurants.area_id = #{a_id} and restaurant_type_ships.type_id = #{t_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").order("(ABS(#{x}-x_lat) + ABS(#{y}-y_long)) ASC").paginate(:page => params[:page], :per_page => 16)
            end
          elsif a_id == nil
            if is_service_order == nil && is_dis_order == nil 
              rs = Restaurant.joins(:restaurant_type_ships).where("restaurant_type_ships.type_id = #{t_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").paginate(:page => params[:page], :per_page => 16)
            elsif is_service_order == "true" && is_dis_order == nil
              rs = Restaurant.joins(:restaurant_type_ships).where("restaurant_type_ships.type_id = #{t_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price,rate_num").order("rate_num DESC").paginate(:page => params[:page], :per_page => 16)
            elsif is_service_order == nil && is_dis_order == "true"
              rs = Restaurant.joins(:restaurant_type_ships).where("restaurant_type_ships.type_id = #{t_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").order("(ABS(#{x}-x_lat) + ABS(#{y}-y_long)) ASC").paginate(:page => params[:page], :per_page => 16)
            end
          end

          render :json => rs 
      end

      def second_restaurants
          a_id   = params[:area_id]
          sec_c_id   = params[:sec_c_id]
          price_low = params[:price_low]
          price_high = params[:price_high]
          is_service_order = params[:is_service_order]
          is_dis_order = params[:is_dis_order]
          x = params[:x].to_f
          y = params[:y].to_f
          if a_id != nil
            if is_service_order == nil && is_dis_order == nil 
              rs = Restaurant.where("area_id = #{a_id} and second_category_id = #{sec_c_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").paginate(:page => params[:page], :per_page => 16)
            elsif is_service_order == "true" && is_dis_order == nil
              rs = Restaurant.where("area_id = #{a_id} and second_category_id = #{sec_c_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price,rate_num").order("rate_num DESC").paginate(:page => params[:page], :per_page => 16)
            elsif is_service_order == nil && is_dis_order == "true"
              rs = Restaurant.where("area_id = #{a_id} and second_category_id = #{sec_c_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").order("(ABS(#{x}-x_lat) + ABS(#{y}-y_long)) ASC").paginate(:page => params[:page], :per_page => 16)
            end
          elsif a_id == nil
            if is_service_order == nil && is_dis_order == nil 
              rs = Restaurant.where("second_category_id = #{sec_c_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").paginate(:page => params[:page], :per_page => 16)
            elsif is_service_order == "true" && is_dis_order == nil
              rs = Restaurant.where("second_category_id = #{sec_c_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price,rate_num").order("rate_num DESC").paginate(:page => params[:page], :per_page => 16)
            elsif is_service_order == nil && is_dis_order == "true"
              rs = Restaurant.where("second_category_id = #{sec_c_id} and #{price_low} <= price and price <= #{price_high} and is_show = true").select("restaurants.id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").order("(ABS(#{x}-x_lat) + ABS(#{y}-y_long)) ASC").paginate(:page => params[:page], :per_page => 16)
            end
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
            rs = Restaurant.where(id:rs_ids).select("id,name,grade_food,grade_service,pic_url,price").paginate(:page => params[:page], :per_page => 16)
            render :json => rs
      end

      def around_restaurates
          # 25.053871,121.460052
          
          x = params[:x].to_f
          y = params[:y].to_f
          c_id = params[:category_id]
          sec_c_id = params[:sec_c_id]

          if c_id!=nil && sec_c_id!=nil
            rs = Restaurant.where("category_id = #{c_id} and second_category_id = #{sec_c_id} and is_show = true").select("id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").order("(ABS(#{x}-x_lat) + ABS(#{y}-y_long)) ASC").paginate(:page => params[:page], :per_page => 16)
          elsif c_id!=nil && sec_c_id ==nil
            rs = Restaurant.where("category_id = #{c_id} and is_show = true").select("id,name,grade_food,grade_service,pic_url,x_lat, y_long,price").order("(ABS(#{x}-x_lat) + ABS(#{y}-y_long)) ASC").paginate(:page => params[:page], :per_page => 16)
          else
            rs = Restaurant.where("is_show = true").select("id,name,grade_food,grade_service,pic_url,x_lat, y_long,price, address").order("(ABS(#{x}-x_lat) + ABS(#{y}-y_long)) ASC").paginate(:page => params[:page], :per_page => 16)
          end
          render :json => rs
      end


end
