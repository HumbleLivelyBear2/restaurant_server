# encoding: utf-8
class CrawlRestaurantWorker
  include Sidekiq::Worker
  sidekiq_options queue: "res"
  
  def perform(res_id)
    res = Restaurant.select("id, ipeen_link").find(res_id)
    crawler = RestaurantCrawler.new
    crawler.fetch res.ipeen_link
    crawler.crawl_res_datas res.id
    # puts novel.id
  end

end