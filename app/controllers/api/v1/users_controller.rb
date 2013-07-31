class Api::V1::UsersController < ApplicationController
  def create
    regid = params[:regid]
    user = User.find_by_registration_id(regid)
    if user
      user.registration_id = regid;
      user.save
    else
      user = User.new
      user.registration_id = regid
      user.looked_restaurants = []
      user.looked_notes = []
      user.save
    end
    render :status=>200, :json => {"message" => "success"}
  end

  def update_looked_restaurants
    regid = params[:regid]
    restaurant = params[:restaurant]
    user = User.find_by_registration_id(regid)
    if user
      user.looked_restaurants << restaurant unless user.looked_restaurants.include? restaurant
      user.save
      render :status=>200, :json => {"message" => "success"}
    else
      render :status=>404, :json => {"message" => "fail"}
    end
  end

  def update_looked_notes
    regid = params[:regid]
    note = params[:note]
    user = User.find_by_registration_id(regid)
    if user
      user.looked_notes << note unless user.looked_notes.include? note
      user.save
      render :status=>200, :json => {"message" => "success"}
    else
      render :status=>404, :json => {"message" => "fail"}
    end
  end

  def update_collect_restaurants
    regid = params[:regid]
    restaurants = params[:restaurants]
    user = User.find_by_registration_id(regid)
    if user
      user.collect_restaurants = restaurants
      user.save
      render :status=>200, :json => {"message" => "success"}
    else
      render :status=>404, :json => {"message" => "fail"}
    end
  end

  def update_collect_notes
    regid = params[:regid]
    notes = params[:notes]
    user = User.find_by_registration_id(regid)
    if user
      user.collect_notes = notes
      user.save
      render :status=>200, :json => {"message" => "success"}
    else
      render :status=>404, :json => {"message" => "fail"}
    end
  end

end
