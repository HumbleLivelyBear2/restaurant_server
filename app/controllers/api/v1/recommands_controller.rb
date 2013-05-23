class Api::V1::RecommandsController < ApplicationController
	def create
		begin
        	a_id = params[:area_id];
        	name = params[:name];
        	grade_food = params[:grade_food];
        	grade_service = params[:grade_service];

			recommand = Recommand.new
			recommand.name = name
			recommand.area_id = area_id
			recommand.grade_food = grade_food
			recommand.grade_service = grade_service
			recommand.save
			return "ok"
		rescue Exception => e
			return "error"
		end
		
	end
end
