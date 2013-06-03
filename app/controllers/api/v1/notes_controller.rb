class Api::V1::NotesController < ApplicationController
	def index

        a_id = params[:area_id];
		c_id = params[:category_id];
        t_id = params[:type_id];
        r_c_id = params[:rank_category_id]

        if a_id !=nil && c_id == nil && t_id == nil && r_c_id == nil
                notes = Note.joins(:restaurant).where("restaurants.area_id = #{a_id}").select("notes.id,notes.restaurant_id,notes.title, notes.author, notes.pic_url,notes.pub_date, notes.ipeen_link, restaurants.x_lat, restaurants.y_long").paginate(:page => params[:page], :per_page => 15)
        elsif  a_id ==nil && c_id != nil && t_id == nil && r_c_id == nil
                ids_rs = Restaurant.where(:category_id => c_id).select("id")
                notes = Note.joins(:restaurant).where(restaurant_id: ids_rs).select("notes.id,notes.restaurant_id,notes.title, notes.author, notes.pic_url,notes.pub_date, notes.ipeen_link, restaurants.x_lat, restaurants.y_long").paginate(:page => params[:page], :per_page => 15)
        elsif  a_id ==nil && c_id == nil && t_id != nil && r_c_id == nil
                type =  Type.find(t_id)
                ids_rs = type.restaurants.select("restaurants.id")
                notes = Note.joins(:restaurant).where(restaurant_id: ids_rs).select("notes.id,notes.restaurant_id,notes.title, notes.author, notes.pic_url,notes.pub_date, notes.ipeen_link, restaurants.x_lat, restaurants.y_long").paginate(:page => params[:page], :per_page => 15)
        elsif a_id ==nil && c_id == nil && t_id == nil && r_c_id != nil
                rc = RankCategory.find(r_c_id)
                ids_rs = rc.restaurants.select("restaurants.id")
                notes = Note.joins(:restaurant).where(restaurant_id: ids_rs).select("notes.id,notes.restaurant_id,notes.title, notes.author, notes.pic_url,notes.pub_date, notes.ipeen_link, restaurants.x_lat, restaurants.y_long").paginate(:page => params[:page], :per_page => 15)
        elsif a_id !=nil && c_id != nil && t_id == nil && r_c_id == nil
                ids_rs = Restaurant.where(:category_id => c_id, :area_id => a_id).select("id")
                notes = Note.joins(:restaurant).where(restaurant_id: ids_rs).select("notes.id,notes.restaurant_id,notes.title, notes.author, notes.pic_url,notes.pub_date, notes.ipeen_link, restaurants.x_lat, restaurants.y_long").paginate(:page => params[:page], :per_page => 15)
        elsif a_id !=nil && c_id == nil && t_id != nil && r_c_id == nil
                ids_rs = Restaurant.joins(:restaurant_type_ships).where("restaurants.area_id = #{a_id} and restaurant_type_ships.type_id = #{t_id}").select("restaurants.id")   
                notes = Note.joins(:restaurant).where(restaurant_id: ids_rs).select("notes.id,notes.restaurant_id,notes.title, notes.author, notes.pic_url,notes.pub_date, notes.ipeen_link, restaurants.x_lat, restaurants.y_long").paginate(:page => params[:page], :per_page => 15)
        elsif a_id !=nil && c_id == nil && t_id == nil && r_c_id != nil
                ids_rs = Restaurant.joins(:restaurant_category_rank_ships).where("restaurants.area_id = #{a_id} and restaurant_category_rank_ships.rank_category_id = #{r_c_id}").select("restaurants.id") 
                notes = Note.joins(:restaurant).where(restaurant_id: ids_rs).select("notes.id,notes.restaurant_id,notes.title, notes.author, notes.pic_url,notes.pub_date, notes.ipeen_link, restaurants.x_lat, restaurants.y_long").paginate(:page => params[:page], :per_page => 15)
        end 
            	
		render :json => notes

	end

	def show
		r_id = params[:id]
		notes = Note.joins(:restaurant).where(:restaurant_id => r_id).select("notes.id,notes.restaurant_id,notes.title, notes.author, notes.pic_url,notes.pub_date, notes.ipeen_link, restaurants.x_lat, restaurants.y_long").paginate(:page => params[:page], :per_page => 15)
		render :json => notes
	end

    def second_notes
        a_id   = params[:area_id];
        sec_c_id   = params[:sec_c_id];
        if a_id ==nil 
          notes = Note.joins(:restaurant).where("restaurants.second_category_id= #{sec_c_id}").select("notes.id,notes.restaurant_id,notes.title, notes.author, notes.pic_url,notes.pub_date, notes.ipeen_link, restaurants.x_lat, restaurants.y_long").paginate(:page => params[:page], :per_page => 15)
        else
          notes = Note.joins(:restaurant).where("restaurants.second_category_id= #{sec_c_id} and restaurants.area_id=#{a_id}").select("notes.id,notes.restaurant_id,notes.title, notes.author, notes.pic_url,notes.pub_date, notes.ipeen_link, restaurants.x_lat, restaurants.y_long").paginate(:page => params[:page], :per_page => 15)
        end
          render :json => notes
    end



    def select_notes
        n_ids = SelectedNote.select("note_id")
        notes = Note.where(id:n_ids).joins(:restaurant).select("notes.id,notes.restaurant_id,notes.title, notes.author, notes.pic_url,notes.pub_date, notes.ipeen_link, restaurants.x_lat, restaurants.y_long").paginate(:page => params[:page], :per_page => 15)
        render :json => notes
    end

end
