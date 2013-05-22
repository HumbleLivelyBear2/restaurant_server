class Api::V1::RecommandsController < ApplicationController
	def create
		begin
			recommand = Recommand.new
			recommand.name = "test"
			recommand.area_id = 1
			recommand.save
			return "ok"
		rescue Exception => e
			return "error"
		end
		
	end
end
