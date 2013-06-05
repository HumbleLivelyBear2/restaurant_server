# encoding: utf-8
class TransferFoodAndServiceWorker
  include Sidekiq::Worker
  sidekiq_options queue: "res"
  
  def perform(res_id)
    res = Restaurant.select("id, grade_food, grade_service").find(res_id)
    text = res.grade_food
    text = text[0..text.index("%")-1]
    int_food = text.to_i
    res.int_food = int_food
    text = res.grade_service
    text = text[0..text.index("%")-1]
    int_service = text.to_i
    res.int_service = int_service
    res.save
  end

end