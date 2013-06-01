# encoding: utf-8
class CrawlRankCategoryShipWorker
  include Sidekiq::Worker
  sidekiq_options queue: "res"
  
  def perform(rank_cate_id)
  	ipeen_url = "http://www.ipeen.com.tw/"
  	Area.all.each do |area|
    	rank_category = RankCategory.find(rank_cate_id)
    	url = ipeen_url + area.code_name + rank_category.code_number
    	c = RestaurantCrawler.new
    	c.fetch url
    	
    	is_crawl = true
	    while is_crawl do
	      num = c.page_html.css(".rankItem").size()
	      i = 0
	      while i < num do
	      	puts rank_category.name + " " +area.name + " item:" + i.to_s
	      	text = c.page_html.css(".rankItem")[i].css(".rankShop a")[0][:href]
	      	link =  "http://www.ipeen.com.tw" +  URI::encode(text)
	      	res = Restaurant.find_by_ipeen_link(link)
	        if (res!= nil)
	        	res_category_rank_ship = RestaurantCategoryRankShip.new
	        	res_category_rank_ship.restaurant_id = res.id
	        	res_category_rank_ship.rank_category_id = rank_category.id
	        	res_category_rank_ship.area_id = area.id
	        	res_category_rank_ship.save
	        end
	        i = i + 1
	      end

	      if (c.page_html.css("label.next_p_one").size() == 2)
	        url = "http://www.ipeen.com.tw" + c.page_html.css("label.next_p_one")[0].children[0][:href]
	        c.fetch url
	      else
	        is_crawl = false
	      end
	    end
	end
    # puts novel.id
  end

end