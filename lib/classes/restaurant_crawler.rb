# encoding: utf-8
class RestaurantCrawler
  include Crawler


  def change_node_br_to_newline node
    content = node.to_html
    content = content.gsub("<br>","\n")
    n = Nokogiri::HTML(content)
    n.text
  end


  
end
