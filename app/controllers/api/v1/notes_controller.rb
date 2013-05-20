class Api::V1::NotesController < ApplicationController
	def index
		a_id = params[:area_id]
		notes = Note.where(:area_id => a_id).index_select.paginate(:page => params[:page], :per_page => 15)
		render :json => notes
	end

	def show
		r_id = params[:id]
		notes = Note.where(:restaurant_id => r_id).index_select
		render :json => notes
	end
end
