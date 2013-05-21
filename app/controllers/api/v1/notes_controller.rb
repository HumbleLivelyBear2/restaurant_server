class Api::V1::NotesController < ApplicationController
	def index
		c_id = params[:category_id];
        a_id = params[:area_id];
        t_id = params[:type_id];

        if (t_id ==nil)
        	if (a_id != nil && c_id != nil) 
                c = Category.find(c_id)
                ids_rs = c.restaurants.where(:area_id => a_id).select("restaurants.id")
                notes = Note.where(restaurant_id: ids_rs).index_select.paginate(:page => params[:page], :per_page => 15)
            elsif (a_id != nil && c_id == nil) 
                notes = Note.where(:area_id => a_id).index_select.paginate(:page => params[:page], :per_page => 15)
            elsif (c_id != nil && a_id == nil)
                c = Category.find(c_id)
                ids_rs = c.restaurants.select("restaurants.id")
                notes = Note.where(restaurant_id: ids_rs).index_select.paginate(:page => params[:page], :per_page => 15)
            end 
        elsif t_id !=nil
            if (a_id != nil)
                ids_rs = Restaurant.joins(:restaurant_type_ships).where("area_id = #{a_id} and type_id = #{t_id}").select("restaurants.id")               
                notes = Note.where(restaurant_id: ids_rs).index_select.paginate(:page => params[:page], :per_page => 15)
            elsif a_id == nil
                ids_rs = Restaurant.joins(:restaurant_type_ships).where("type_id = #{t_id}").select("restaurants.id")
                notes = Note.where(restaurant_id: ids_rs).index_select.paginate(:page => params[:page], :per_page => 15)
            end
        end  
            	
		

		render :json => notes


	end

	def show
		r_id = params[:id]
		notes = Note.where(:restaurant_id => r_id).index_select
		render :json => notes
	end
end
