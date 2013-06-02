# encoding: utf-8
namespace :crawl do

    # 1.crawl_second_category
    # 2.crawl_restaurant
    # 3.crawl_restaurant_datail
    # 4.crawl_restaurant_note
    # 5.crawl_type_ship
    # 6.crawl_rank_category_ship

    task :crawl_second_category => :environment do
      c = RestaurantCrawler.new
      c.fetch "http://www.ipeen.com.tw/taiwan/channel/F"
      nodes = c.page_html.css(".allCate tr")
      nodes.each do |node|
        Category.all.each do |c|
          if c.name == node.children[0].text.strip
            puts c.name
            inside_nodes = node.children[2].children[1].children
            inside_nodes.each do |n|            
              if n.text.strip != ""
                sec_c = SecondCategory.new
                sec_c.name = n.text.strip
                text = n.children[0][:href]
                text = text.gsub("/search/taiwan","")
                sec_c.code_number = text
                sec_c.is_show = true
                sec_c.category_id = c.id
                sec_c.save
              end
            end
          end
        end     
      end
      url = "http://www.ipeen.com.tw/search/taiwan"
      SecondCategory.all.each do |cate|
        puts "get num" + " "+cate.name
        c = RestaurantCrawler.new
        c.fetch url+cate.code_number
        if c.page_html.css("label.next_p_s").size() != 0
            text = c.page_html.css("label.next_p_s").children[0][:href]
            index = text.index("p=")
            num = text[index+2..text.length].to_i
            cate.max_page_num = num
        else
            num = 1
            cate.max_page_num = 1
        end
        cate.save
      end
    end

    task :crawl_restaurant => :environment do
        url = "http://www.ipeen.com.tw/search/taiwan"
        SecondCategory.all.each do |cate|
            puts cate.name + " " + cate.max_page_num.to_s
            current_num = 1
            while current_num <= cate.max_page_num do
                puts "page=" + current_num.to_s
                CrawlPageResWorker.perform_async(url+cate.code_number+"?p="+current_num.to_s, cate.id)
                current_num = current_num + 1
            end
        end
    end

    task :crawl_restaurant_datail => :environment do
        Restaurant.all.each do |res|
            CrawlRestaurantWorker.perform_async(res.id)
        end
    end

    task :crawl_restaurant_note => :environment do
        Restaurant.all.each do |res|
            CrawlNoteWorker.perform_async(res.id)
        end
    end

    task :crawl_type_ship => :environment do
        Type.all.each do |type|
            CrawlTypeShipWorker.perform_async(type.id)
        end
    end

    task :crawl_rank_category_ship => :environment do
        RankCategory.all.each do |rank_category|
            CrawlRankCategoryShipWorker.perform_async(rank_category.id)
        end
    end

    task :make_selected_res_table => :environment do
        rs = Restaurant.select("id, is_show").all(:order => "rate_num")
        rs = rs.reverse
        i = 0
        while i < 100 do
            puts i
            if rs[i].is_show == true
                sr = SelectedRestaurant.new
                sr.restaurant_id = rs[i].id
                sr.save
            end
            i = i +1
        end
    end

    task :make_selected_note_table => :environment do
        rs_ids = SelectedRestaurant.select("restaurant_id")
        notes = Note.where(:restaurant_id => rs_ids)
        notes = notes.shuffle
        i = 0
        while i < 100 do
            puts i           
            sn = SelectedNote.new
            sn.note_id = notes[i].id
            sn.save
            i = i +1
        end
    end

  ### below is for eztable 
  # 1.crawl_area
  # 2.crawl_area_restaurant
  # 3.crawl_restaruant
  # 4.crawl_restaurant_category
  # 5.crawl_address

    # task :crawl_address => :environment do
    #   Restaurant.all.each do |res|
    #     c = RestaurantCrawler.new
    #     url = "http://map.longwin.com.tw/addr_geo.php?addr=" + res.address
    #     c.fetch URI::encode(url)
    #     num = c.page_html.css("script").text.index("GLatLng")
    #     text = c.page_html.css("script").text[num..num+35]
    #     num1 = text.index("(")
    #     num2 = text.index(",")
    #     num3 = text.index(")")
    #     x = text[num1+1..num2-1]
    #     y = text[num2+1..num3-1]
    #     res.x_lan = x
    #     res.y_long = y
    #     puts res.name
    #     puts x.to_s + " "+ y.to_s
    #     res.save
    #     sleep(2) 
    #   end
    # end

    # task :crawl_restaurant_category => :environment do
    #   Area.all.each do |area|
    #     area.categories.each do |c|
    #       puts area.name + "---" + c.name
    #       crawler = RestaurantCrawler.new
    #       url = "http://www.eztable.com/channel.php?channel_name="+c.name+"&city="+area.name+"&date=2013-05-15&people=2"
    #       crawler.fetch URI::encode(url)

    #       if(crawler.page_html.css(".next").size() == 0)
    #         parseResCateShip(url, c.id)
    #       else
    #         crawler.page_html.css('.pagination a').last.remove
    #         page_num = crawler.page_html.css('.pagination a').last.text.strip.to_i
    #         i = 1
    #         while i <=  page_num do
    #           puts "crawl page "+ i.to_s
    #           parseResCateShip("http://www.eztable.com/channel.php?channel_name="+c.name+"&city="+area.name+"&date=2013-05-15&people=2&page="+i.to_s, c.id)
    #           i = i+1
    #         end
    #       end
    #     end
    #   end
    # end

    # def parseResCateShip(url, category_id)
    #   crawler = RestaurantCrawler.new
    #   crawler.fetch URI::encode(url)
    #   res_num = crawler.page_html.css('.rank_photo').size()
    #   current_i = 1
    #   while current_i <= res_num do
    #     puts current_i
    #     res_name = crawler.page_html.css('.rank_list h2 a')[current_i-1].text.strip
    #     res = Restaurant.where( :name => res_name)
    #     rcship = RestaurantCategoryShip.new
    #     rcship.restaurant_id = res[0][:id]
    #     rcship.category_id = category_id
    #     rcship.save
    #     current_i = current_i + 1
    #   end
    # end

    # task :crawl_area_restaurant => :environment do
    #   Area.all.each do |area|
    #     c1 = RestaurantCrawler.new
    #     puts "crawling" + area.name
    #     area_url = "http://www.eztable.com/channel.php?city="+area.name+"&date=2013-05-14&people=2&channel_name=本週特別推薦"
    #     c1.fetch URI::encode(area_url)

    #     if (c1.page_html.css(".next").size() == 0)
    #       parseAreaRestaurant( "http://www.eztable.com/channel.php?city="+area.name+"&date=2013-05-14&people=2&channel_name=本週特別推薦",area.id);
    #     else
    #       c1.page_html.css('.pagination a').last.remove
    #       page_num = c1.page_html.css('.pagination a').last.text.strip.to_i
    #       i = 1
    #       while i <=  page_num do
    #         puts "crawl page "+ i.to_s
    #         parseAreaRestaurant("http://www.eztable.com/channel.php?city="+area.name+"&date=2013-05-14&people=2&channel_name=本週特別推薦&page="+ i.to_s , area.id)
    #         i = i+1
    #       end
    #     end
    #   end
    # end

    # def parseAreaRestaurant(url, area_id)
    #   crawler = RestaurantCrawler.new
    #   crawler.fetch URI::encode(url)
    #   res_num = crawler.page_html.css('.rank_photo').size()
    #   current_i = 1
    #   while current_i <= res_num do
    #     puts current_i.to_s
    #     res = Restaurant.new
    #     res.name = crawler.page_html.css('.rank_list h2 a')[current_i-1].text.strip
    #     puts res.name
    #     res.eztable_link = "http://www.eztable.com" + crawler.page_html.css('.rank_list h2 a')[current_i-1][:href]
    #     res.eztable_link = res.eztable_link.gsub("../..","")
    #     res.pic_url = crawler.page_html.css('.rank_photo img')[current_i-1][:src]
    #     res.area_id = area_id
    #     text_food  = crawler.page_html.css(".rank_list li span.food")[current_i-1].text.strip
    #     res.grade_food = text_food.gsub("菜色 ： ","")
    #     text_ambiance = crawler.page_html.css(".rank_list li span.ambiance")[current_i-1].text.strip
    #     res.grade_ambiance = text_ambiance.gsub("氣氛 ： ","")
    #     text_service = crawler.page_html.css(".rank_list li span.meta-list")[current_i*3-1].text.strip
    #     res.grade_service = text_service.gsub("服務 ： ","")
    #     res.save
    #     current_i = current_i + 1
    #   end 
    # end

    # task :crawl_restaruant => :environment do
    #   Restaurant.all.each do |r|
    #     c = RestaurantCrawler.new
    #     puts r.name
    #     c.fetch r.eztable_link
    #     c.page_html.css("div[itemprop = 'FoodEstablishment']").remove
    #     # r.name = c.page_html.css("h1 > span[itemprop]").text.strip
    #     r.address = c.page_html.css("address").text.strip
    #     r.open_time = c.page_html.css("h4[itemprop = 'openingHours'] > .rest_li").text.strip
    #     r.official_link = c.page_html.css("h4 a[itemprop='url']").text.strip

    #     types = c.page_html.css(".rest_li a")

    #     types.each do |t|
    #       name = t.text.strip
    #       puts name
    #       #  add type
    #       type = Type.find_by_name(name)

    #       unless type
    #         type = Type.new
    #         type.name = name
    #         type.save
    #       end

    #       ship = RestaurantTypeShip.new
    #       ship.type_id = type.id
    #       ship.restaurant_id = r.id
    #       ship.save

    #     end

    #     r.eat_type = c.page_html.css("a[target='_self']").text.strip
    #     r.price = c.page_html.css("li[itemprop='priceRange']").text.strip
    #     # get traffic info
    #     c.page_html.css("li[itemprop='priceRange']").remove
    #     c.page_html.css("a[target='_self']").remove
    #     c.page_html.css("h4[itemprop = 'openingHours'] > .rest_li").remove
    #     text = c.page_html.css(".rest_li").text.strip
    #     text = text.gsub(" ","")
    #     while text.index("\n\n")!=nil do
    #       text = text.gsub("\n\n","\n")
    #     end
    #     r.traffic = text
    #     c.page_html.css(".messageBox").remove
    #     r.introduction = c.page_html.css("p[itemprop='description']").text.strip
    #     r.save
    #     # parse note
    #     note1 = Note.new
    #     note1.title = c.page_html.css('div.gallery  li.first h4').text.strip
    #     note1.intro = c.page_html.css('div.gallery  li.first p a').text.strip
    #     note1.pic_url = c.page_html.css('div.gallery  li.first img')[0][:src]
    #     note1.link = r.official_link
    #     note1.restaurant_id = r.id
    #     note1.area_id = r.area_id
    #     note1.save

    #     note2 = Note.new
    #     note2.title = c.page_html.css('div.gallery  li.sec h3')[0].text.strip
    #     note2.intro = ""
    #     note2.pic_url = c.page_html.css('div.gallery  li.second img')[0][:src]
    #     begin
    #       note2.link = c.page_html.css('div.gallery  li.second a input[name="url"]')[0][:value]
    #     rescue Exception => e
    #       note2.link = "null"
    #     end
    #     note2.restaurant_id = r.id
    #     note2.area_id = r.area_id
    #     note2.save

    #     note3 = Note.new
    #     note3.title = c.page_html.css('div.gallery  li.sec h3')[1].text.strip
    #     note3.intro = ""
    #     note3.pic_url = c.page_html.css('div.gallery  li.sec a img')[1][:src]
    #     begin
    #       note3.link = c.page_html.css('div.gallery  li.sec div.ic_caption a')[1][:href]
    #     rescue Exception => e
    #       note3.link = "null"
    #     end
    #     note3.restaurant_id = r.id
    #     note3.area_id = r.area_id
    #     note3.save
    #   end
    # end

    # # crawl area and relation table the same task
    # task :crawl_area => :environment do
    #   i =1
    #   crawler = RestaurantCrawler.new
    #   crawler.fetch 'http://www.eztable.com/channel.php?city=%E5%8F%B0%E5%8C%97%E5%B8%82&date=2013-05-14&people=2&channel_name=%E6%9C%AC%E9%80%B1%E7%89%B9%E5%88%A5%E6%8E%A8%E8%96%A6'
    #   crawler.page_html.css(".li_1 option").each do |a|
    #     text = a.text
    #     if text != "不拘"
    #       puts text
    #       area = Area.new
    #       area.name = text
    #       area.save
    #       parseRelation("http://www.eztable.com/channel.php?city="+text+"&date=2013-05-14&people=2&channel_name=本週特別推薦", i)
    #       i= i+1
    #     end
    #   end
    # end

    # def parseRelation(url, area_id)
    #     crawler = RestaurantCrawler.new
    #     crawler.fetch URI::encode(url)
    #     crawler.page_html.css(".drop1 li").each do |a|
    #           text = a.text
    #           puts text;
    #           if text.index('B1F') != nil
    #             ship = AreaCategoryship.new
    #             ship.area_id = area_id;
    #             ship.category_id = 1;
    #             ship.save  
    #           elsif text.index('1F') != nil
    #             ship = AreaCategoryship.new
    #             ship.area_id = area_id;
    #             ship.category_id = 2;
    #             ship.save
    #           elsif text.index('2F') != nil
    #             ship = AreaCategoryship.new
    #             ship.area_id = area_id;
    #             ship.category_id = 3;
    #             ship.save
    #           elsif text.index('3F') != nil
    #             ship = AreaCategoryship.new
    #             ship.area_id = area_id;
    #             ship.category_id = 4;
    #             ship.save
    #           elsif text.index('4F') != nil
    #             ship = AreaCategoryship.new
    #             ship.area_id = area_id;
    #             ship.category_id = 5;
    #             ship.save
    #           elsif text.index('5F') != nil
    #             ship = AreaCategoryship.new
    #             ship.area_id = area_id;
    #             ship.category_id = 6;
    #             ship.save
    #           elsif text.index('6F') != nil
    #             ship = AreaCategoryship.new
    #             ship.area_id = area_id;
    #             ship.category_id = 7;
    #             ship.save
    #           elsif text.index('7F') != nil
    #             ship = AreaCategoryship.new
    #             ship.area_id = area_id;
    #             ship.category_id = 8;
    #             ship.save
    #           elsif text.index('8F') != nil
    #             ship = AreaCategoryship.new
    #             ship.area_id = area_id;
    #             ship.category_id = 9;
    #             ship.save
    #           elsif text.index('9F') != nil
    #             ship = AreaCategoryship.new
    #             ship.area_id = area_id;
    #             ship.category_id = 10;
    #             ship.save                  
    #           end
    #   end
    # end

end