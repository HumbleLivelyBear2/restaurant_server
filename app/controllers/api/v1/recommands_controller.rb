class Api::V1::RecommandsController < ApplicationController
	def create
        	a_id = params[:area_id];
        	name = params[:name];
        	grade_food = params[:grade_food];
        	grade_service = params[:grade_service];

			recommand = Recommand.new
			recommand.name = name
			recommand.area_id = a_id
			recommand.grade_food = grade_food
			recommand.grade_service = grade_service
			recommand.save
			render :json => ["ok"]
		
	end
end
