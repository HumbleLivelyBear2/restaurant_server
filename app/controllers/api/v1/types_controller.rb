class Api::V1::TypesController < ApplicationController
  def index
    types = Type.select('id,name').all
    render :json => types
  end
end
