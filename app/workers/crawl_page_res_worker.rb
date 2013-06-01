# encoding: utf-8
class CrawlPageResWorker
  include Sidekiq::Worker
  sidekiq_options queue: "res"
  

  def perform(url, c_id)
  	crawler = RestaurantCrawler.new
  	crawler.fetch url
    if crawler.page_html.css(".serItem").size()!= 0
      
      if crawler.page_html.css(".serItem").first.text.strip.index("合作店家")
    	 crawler.page_html.css(".serItem").first.remove
      end
    
      nodes = crawler.page_html.css(".serItem")
    	nodes.each do |node| 		
        res = Restaurant.new
    		res.name = node.css(".name").children.children.text
    		res.pic_url = node.css("img")[0][:src]
        inside_nodes = node.css(".name").children
        inside_nodes.each do |n|
          if n.name == "a"
            res.ipeen_link = URI::encode("http://www.ipeen.com.tw"+n[:href])
          end
        end 
        # if (node.css(".name").children[1][:href]!=nil)
    		  # res.ipeen_link = URI::encode("http://www.ipeen.com.tw"+node.css(".name").children[1][:href])
        # elsif (node.css(".name").children[3][:href]!=nil)
        #   res.ipeen_link = URI::encode("http://www.ipeen.com.tw"+node.css(".name").children[3][:href])
        # end
        res.second_category_id = c_id

        sec_category = SecondCategory.find(res.second_category_id)
        res.category_id = sec_category.category_id
        
        if res.name.index("已歇業")
          res.is_show = false
        else
          res.is_show = true
        end
    		res.save
    	end
    end
  end
  
end