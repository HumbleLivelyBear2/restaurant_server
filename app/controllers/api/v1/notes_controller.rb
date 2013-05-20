class Api::V1::NotesController < ApplicationController
	def index
		a_id = params[:area_id];
		a = Area.find(a_id)
		notes = nil
		a.restaurants.each do |r|
			if notes == nil
				notes = Note.where(:restaurant_id => r.id).index_select
			else
				notes = Note.where(:restaurant_id => r.id).index_select + notes
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
