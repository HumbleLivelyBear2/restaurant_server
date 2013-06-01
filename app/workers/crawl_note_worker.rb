# encoding: utf-8
class CrawlNoteWorker
  include Sidekiq::Worker
  sidekiq_options queue: "res"
  
  def perform(res_id)
    crawler = RestaurantCrawler.new
    crawler.crawl_res_note(res_id)
    # puts novel.id
  end

end