class Api::V1::NotesController < ApplicationController
	def index
		c_id = params[:category_id];
        a_id = params[:area_id];
        t_id = params[:type_id];

        if (t_id ==nil)
        	if (a_id != nil && c_id != nil) 
                c = Category.find(c_id)
                ids_rs = c.restaurants.where(:area_id => a_id).select("restaurants.id")
                notes = Note.joins(:restaurant).where(restaurant_id: ids_rs).select("notes.id,notes.restaurant_id,notes.title, notes.intro, notes.pic_url, notes.link, restaurants.x_lan, restaurants.y_long").paginate(:page => params[:page], :per_page => 15)
            elsif (a_id != nil && c_id == nil) 
                notes = Note.joins(:restaurant).where(:area_id => a_id).select("notes.id,notes.restaurant_id,notes.title, notes.intro, notes.pic_url, notes.link, restaurants.x_lan, restaurants.y_long").paginate(:page => params[:page], :per_page => 15)
            elsif (c_id != nil && a_id == nil)
                c = Category.find(c_id)
                ids_rs = c.restaurants.select("restaurants.id")
                notes = Note.joins(:restaurant).where(restaurant_id: ids_rs).select("notes.id,notes.restaurant_id,notes.title, notes.intro, notes.pic_url, notes.link, restaurants.x_lan, restaurants.y_long").paginate(:page => params[:page], :per_page => 15)
            end 
        elsif t_id !=nil
            if (a_id != nil)
                ids_rs = Restaurant.joins(:restaurant_type_ships).where("area_id = #{a_id} and type_id = #{t_id}").select("restaurants.id")               
                notes = Note.joins(:restaurant).where(restaurant_id: ids_rs).select("notes.id,notes.restaurant_id,notes.title, notes.intro, notes.pic_url, notes.link, restaurants.x_lan, restaurants.y_long").paginate(:page => params[:page], :per_page => 15)
            elsif a_id == nil
                ids_rs = Restaurant.joins(:restaurant_type_ships).where("type_id = #{t_id}").select("restaurants.id")
                notes = Note.joins(:restaurant).where(restaurant_id: ids_rs).select("notes.id,notes.restaurant_id,notes.title, notes.intro, notes.pic_url, notes.link, restaurants.x_lan, restaurants.y_long").paginate(:page => params[:page], :per_page => 15)
            end
        end  
            	
		render :json => notes

	end

	def show
		r_id = params[:id]
		notes = Note.joins(:restaurant).where(:restaurant_id => r_id).select("notes.id,notes.restaurant_id,notes.title, notes.intro, notes.pic_url, notes.link, restaurants.x_lan, restaurants.y_long").paginate(:page => params[:page], :per_page => 15)
		render :json => notes
	end

    def select_notes
        notes = Note.joins(:restaurant).select("notes.id,notes.restaurant_id,notes.title, notes.intro, notes.pic_url, notes.link, restaurants.x_lan, restaurants.y_long").all.sample(15)
        render :json => notes
    end

end
