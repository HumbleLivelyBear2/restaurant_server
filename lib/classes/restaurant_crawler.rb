# encoding: utf-8
class RestaurantCrawler
  include Crawler


  def change_node_br_to_newline node
    content = node.to_html
    content = content.gsub("<br>","\n")
    n = Nokogiri::HTML(content)
    n.text
  end


  def crawl_lat_long res_id
  	res = Restaurant.find(res_id)
  	num = @page_html.css("script").text.index("GLatLng")
  	x = @page_html.css("script").text[num+8..num+18]
  	y = @page_html.css("script").text[num+19..num+28]
  	res.x_lan = x
  	res.y_long = y
  	res.save 
  end


end
