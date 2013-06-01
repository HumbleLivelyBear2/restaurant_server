# encoding: utf-8
class CrawlCoordinateWorker
  include Sidekiq::Worker
  sidekiq_options queue: "res"
  
  def perform(res_id)
    res = Restaurant.select("id, address").find(res_id)
    crawler = RestaurantCrawler.new
    crawler.fetch_address_site res.address
    crawler.crawl_lat_long res_id
    # puts novel.id
  end

end