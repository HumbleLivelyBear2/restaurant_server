class Api::V1::UsersController < ApplicationController
  def create
    render :status=>404, :json => {"message" => "fail"} and return unless params[:device_id]
    user = find_user
    if user
      user.registration_id = params[:regid]
      user.save
    else
      user = User.new
      user.device_id = params[:device_id]
      user.registration_id = params[:regid]
      user.looked_restaurants = []
      user.looked_notes = []
      user.save
    end
    render :status=>200, :json => {"message" => "success"}
  end

  def update_looked_restaurants
    restaurant = params[:restaurant]
    user = find_user
    if user
      user.looked_restaurants << restaurant unless user.looked_restaurants.include? restaurant
      user.save
      render :status=>200, :json => {"message" => "success"}
    else
      render :status=>404, :json => {"message" => "fail"}
    end
  end

  def update_looked_notes
    note = params[:note]
    user = find_user
    if user
      user.looked_notes << note unless user.looked_notes.include? note
      user.save
      render :status=>200, :json => {"message" => "success"}
    else
      render :status=>404, :json => {"message" => "fail"}
    end
  end

  def update_collect_restaurants
    restaurants = params[:restaurants]
    user = find_user
    if user
      user.collect_restaurants = restaurants
      user.save
      render :status=>200, :json => {"message" => "success"}
    else
      render :status=>404, :json => {"message" => "fail"}
    end
  end

  def update_collect_notes
    notes = params[:notes]
    user = find_user
    if user
      user.collect_notes = notes
      user.save
      render :status=>200, :json => {"message" => "success"}
    else
      render :status=>404, :json => {"message" => "fail"}
    end
  end

  private
    def find_user
      device_id = params[:device_id]
      return nil unless device_id
      user = User.find_by_device_id(device_id)
    end

end
