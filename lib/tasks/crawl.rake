# encoding: utf-8
namespace :crawl do

    # 1.crawl_second_category
    # 2.crawl_restaurant
    # 3.crawl_restaurant_datail
    # 4.crawl_restaurant_note
    # 5.crawl_type_ship
    # 6.crawl_rank_category_ship

    # 7.make_selected_res_table
    # 8.make_selected_note_table

    # 9.transfer_food_and_service_int
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

        last_ship = RestaurantCategoryRankShip.last

        RankCategory.all.each do |rank_category|
            rank_cate_id = rank_category.id
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
            # CrawlRankCategoryShipWorker.perform_async(rank_category.id)
        end

        RestaurantCategoryRankShip.delete_all("id <= #{last_ship.id}")
    end

    task :make_selected_res_table => :environment do
        SelectedRestaurant.delete_all
        rs = Restaurant.select("id, is_show").order("rate_num DESC").limit(1500)
        rs = rs.shuffle
        i = 0
        while i < 200 do
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
        SelectedNote.delete_all
        rs_ids = SelectedRestaurant.select("restaurant_id")
        notes = Note.where(:restaurant_id => rs_ids)
        
        (1..100).each do |i|
            notes = notes.shuffle
        end

        i = 0
        while i < 200 do
            puts i           
            sn = SelectedNote.new
            sn.note_id = notes[i].id
            sn.save
            i = i +1
        end
    end

    task :transfer_food_and_service_int => :environment do
        Restaurant.all.each do |res|
            TransferFoodAndServiceWorker.perform_async(res.id)
        end
    end

  task :send_notification_restaurant_note => :environment do
    gcm = GCM.new("AIzaSyBSeIzNxqXm2Rr4UnThWTBDXiDchjINbrc")
    users = User.select("registration_id").all
    registration_ids = []
    users.each{|user| registration_ids << user.registration_id}
    note_id = SelectedNote.select("note_id").shuffle[0].note_id
    note = Note.find(note_id)
    # registration_ids= ["APA91bG92Mmy4WPOyNdTcNdeJMtpM0o4UnjxylGNQmxUBo6t6gehTQCQkCqWsLY7jXUF9kjUUaJP2GgcaIL3HIeXmcXgQcqZxr2hFc481bgH0nPgc7I6wvJR6zo6kAmpQN-Rz3URI3RydwhjhxwhWA6Nky1q5DDMK33gl1w6kADWLhx_3z75jYM"]
    options = {data: {
                  activity: 1, 
                  title: "每日嚴選食記: " + note.restaurant.name, 
                  big_text: note.title, 
                  content: note.restaurant.name + ":" + note.title, 
                  resturant_name: note.restaurant.name, 
                  resturant_id: note.restaurant.id,
                  note_title: note.title,
                  note_link: note.ipeen_link,
                  note_pic: note.pic_url,
                  note_id: note.id,
                  restaurant_id: note.restaurant.id,
                  note_x: note.restaurant.x_lat,
                  note_y: note.restaurant.y_long
                  }, collapse_key: "updated_score"}
    response = gcm.send_notification(registration_ids, options)
  end

  task :send_notification_restaurant => :environment do
    gcm = GCM.new("AIzaSyBSeIzNxqXm2Rr4UnThWTBDXiDchjINbrc")
    users = User.select("registration_id").all
    registration_ids = []
    users.each{|user| registration_ids << user.registration_id}
    restaurant_id = SelectedRestaurant.select("restaurant_id").shuffle[0].restaurant_id
    restaurant = Restaurant.find(restaurant_id)
    # registration_ids= ["APA91bG92Mmy4WPOyNdTcNdeJMtpM0o4UnjxylGNQmxUBo6t6gehTQCQkCqWsLY7jXUF9kjUUaJP2GgcaIL3HIeXmcXgQcqZxr2hFc481bgH0nPgc7I6wvJR6zo6kAmpQN-Rz3URI3RydwhjhxwhWA6Nky1q5DDMK33gl1w6kADWLhx_3z75jYM"]
    options = {data: {
                  activity: 0, 
                  title: "每日餐廳介紹: " + restaurant.name, 
                  big_text: restaurant.introduction, 
                  content: restaurant.name + ":" + restaurant.introduction, 
                  resturant_name: restaurant.name, 
                  resturant_id: restaurant.id,
                  note_title: "test",
                  note_link: "http://www.ipeen.com.tw/comment/10000",
                  note_pic: "http://iphoto.ipeen.com.tw/photo/comment/def/200x200/0/0/0/100000/100000_1345063915_7964.jpg",
                  note_id: 5,
                  restaurant_id: 4,
                  note_x: 25.1228120000,
                  note_y: 121.9163060000
                  }, collapse_key: "updated_score"}
    response = gcm.send_notification(registration_ids, options)
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