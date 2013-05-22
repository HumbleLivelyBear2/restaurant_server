module Crawler
  
  require 'nokogiri'
  require 'open-uri'
  require 'iconv'
  require 'net/http'
  
  attr_accessor :page_url, :page_html, :res_address
  
  def fetch_address_site res_address
    @res_address = res_address
    url = "http://map.longwin.com.tw/addr_geo.php?addr=" + @res_address
    @page_url = URI::encode(url)
    @page_html = get_page(@page_url)
  end

  def fetch url
    @page_url = url
    @page_html = get_page(@page_url)   
  end

  def fetch_db_json url
    @page_url = url
    body = ''
    begin
      open(url){ |io|
          body = io.read
      }
    rescue
    end
    @page_html = body
  end

  def post_fetch url, option
    @page_url = url
    url = URI.parse(url)
    resp, data = Net::HTTP.post_form(url, option)
    @page_html = Nokogiri::HTML(resp.body)
  end
  
  def get_page url
    
    @page_url = url
    body = ''
    begin
      open(url){ |io|
          body = io.read
      }
    rescue
    end
    doc = Nokogiri::HTML(body)
    
  end

  
  def get_item_href dns, src
    if (/^\/\// =~ src)
      src = "http:" + src
    elsif (/^\// =~ src)
      src = dns + src
    elsif (/\.\./ =~ src)
      src = dns + src[2..src.length]
    else
      src 
    end
  end
  
  def parse_dns
    url_scan = @page_url.scan(/.*?\//)
    dns = url_scan[0] + url_scan[1] + url_scan[2]
  end

  
end