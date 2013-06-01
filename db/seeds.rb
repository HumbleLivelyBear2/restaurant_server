# encoding: UTF-8


c = Category.new
c.name = '中式料理'
c.photo_url = 'null'
c.code_number = "/000/0-0-27-0/"
c.max_page_num = 1381
c.is_show = true
c.save

c = Category.new
c.name = '日式料理'
c.photo_url = 'null'
c.code_number = "/000/0-0-2-0/"
c.max_page_num = 402
c.is_show = true
c.save

c = Category.new
c.name = '亞洲料理'
c.photo_url = 'null'
c.code_number = "/000/0-0-4-0/"
c.max_page_num = 154
c.is_show = true
c.save

c = Category.new
c.name = '異國料理'
c.photo_url = 'null'
c.code_number = "/000/0-0-25-0/"
c.max_page_num = 467
c.is_show = true
c.save

c = Category.new
c.name = '燒烤類'
c.photo_url = 'null'
c.code_number = "/000/0-0-19-0/"
c.max_page_num = 198
c.is_show = true
c.save

c = Category.new
c.name = '鍋類'
c.photo_url = 'null'
c.code_number = "/000/0-0-21-0/"
c.max_page_num = 398
c.is_show = true
c.save

c = Category.new
c.name = '咖啡、簡餐、茶'
c.photo_url = 'null'
c.code_number = "/000/0-0-17-0/"
c.max_page_num = 751
c.is_show = true
c.save

c = Category.new
c.name = '素食'
c.photo_url = 'null'
c.code_number = "/000/0-0-6-0/"
c.max_page_num = 131
c.is_show = true
c.save

c = Category.new
c.name = '速食料理'
c.photo_url = 'null'
c.code_number = "/000/0-0-9-0/"
c.max_page_num = 124
c.is_show = true
c.save

c = Category.new
c.name = '主題特色餐廳'
c.photo_url = 'null'
c.code_number = "/000/0-0-23-0/"
c.max_page_num = 179
c.is_show = true
c.save

c = Category.new
c.name = 'buffet自助餐'
c.photo_url = 'null'
c.code_number = "/000/0-0-127-0/"
c.max_page_num = 5
c.is_show = true
c.save

a = Area.new
a.name = "全台灣"
a.code_name = "taiwan"
a.area_num = 0
a.save

a = Area.new
a.name = "基隆市"
a.code_name = "keelung"
a.area_num = 1
a.save

a = Area.new
a.name = "台北市"
a.code_name = "taipei"
a.area_num = 1
a.save

a = Area.new
a.name = "新北市"
a.code_name = "xinbei"
a.area_num = 1
a.save

a = Area.new
a.name = "桃園縣"
a.code_name = "taoyuan"
a.area_num = 1
a.save

a = Area.new
a.name = "新竹市"
a.code_name = "hsinchu"
a.area_num = 1
a.save

a = Area.new
a.name = "新竹縣"
a.code_name = "hsinchucounty"
a.area_num = 1
a.save

a = Area.new
a.name = "苗栗縣"
a.code_name = "miaoli"
a.area_num = 1
a.save

a = Area.new
a.name = "台中市"
a.code_name = "taichung"
a.area_num = 2
a.save

a = Area.new
a.name = "南投縣"
a.code_name = "nantou"
a.area_num = 2
a.save

a = Area.new
a.name = "彰化縣"
a.code_name = "changhua"
a.area_num = 2
a.save

a = Area.new
a.name = "雲林縣"
a.code_name = "yunlin"
a.area_num = 2
a.save

a = Area.new
a.name = "嘉義市"
a.code_name = "chiayi"
a.area_num = 3
a.save

a = Area.new
a.name = "嘉義縣"
a.code_name = "chiayicounty"
a.area_num = 3
a.save

a = Area.new
a.name = "台南市"
a.code_name = "tainan"
a.area_num = 3
a.save

a = Area.new
a.name = "高雄市"
a.code_name = "kaohsiung"
a.area_num = 3
a.save

a = Area.new
a.name = "屏東縣"
a.code_name = "pingtung"
a.area_num = 3
a.save

a = Area.new
a.name = "宜蘭縣"
a.code_name = "ilan"
a.area_num = 4
a.save

a = Area.new
a.name = "花蓮縣"
a.code_name = "hualien"
a.area_num = 4
a.save

a = Area.new
a.name = "台東縣"
a.code_name = "taitung"
a.area_num = 4
a.save

a = Area.new
a.name = "澎湖縣"
a.code_name = "penghu"
a.area_num = 4
a.save

a = Area.new
a.name = "連江縣"
a.code_name = "lianjiang"
a.area_num = 4
a.save

a = Area.new
a.name = "金門縣"
a.code_name = "kinmen"
a.area_num = 4
a.save

t = Type.new
t.name = "節日聚餐"
t.code_number = "/rank/F_0_0_0_1_0/"
t.save

t = Type.new
t.name = "情侶約會"
t.code_number = "/rank/F_0_0_0_2_0/"
t.save

t = Type.new
t.name = "家庭聚會"
t.code_number = "/rank/F_0_0_0_3_0/"
t.save

t = Type.new
t.name = "朋友聚會"
t.code_number = "/rank/F_0_0_0_4_0/"
t.save

t = Type.new
t.name = "團體聚會"
t.code_number = "/rank/F_0_0_0_5_0/"
t.save

t = Type.new
t.name = "最佳口味"
t.code_number = "/rank/F_0_0_0_0_1/"
t.save

t = Type.new
t.name = "最佳服務"
t.code_number = "/rank/F_0_0_0_0_2/"
t.save

t = Type.new
t.name = "最佳環境"
t.code_number = "/rank/F_0_0_0_0_3/"
t.save

rc = RankCategory.new
rc.name = '中式料理'
rc.photo_url = 'null'
rc.code_number = "/rank/F_0_0_1_0_0/"
rc.is_show = true
rc.save

rc = RankCategory.new
rc.name = '台式料理'
rc.photo_url = 'null'
rc.code_number = "/rank/F_0_0_2_0_0/"
rc.is_show = true
rc.save

rc = RankCategory.new
rc.name = '日式料理'
rc.photo_url = 'null'
rc.code_number = "/rank/F_0_0_3_0_0/"
rc.is_show = true
rc.save

rc = RankCategory.new
rc.name = '歐式料理'
rc.photo_url = 'null'
rc.code_number = "/rank/F_0_0_4_0_0/"
rc.is_show = true
rc.save

rc = RankCategory.new
rc.name = '南洋料理'
rc.photo_url = 'null'
rc.code_number = "/rank/F_0_0_5_0_0/"
rc.is_show = true
rc.save

rc = RankCategory.new
rc.name = '鍋類料理'
rc.photo_url = 'null'
rc.code_number = "/rank/F_0_0_6_0_0/"
rc.is_show = true
rc.save

rc = RankCategory.new
rc.name = '燒烤料理'
rc.photo_url = 'null'
rc.code_number = "/rank/F_0_0_7_0_0/"
rc.is_show = true
rc.save

rc = RankCategory.new
rc.name = '下午茶'
rc.photo_url = 'null'
rc.code_number = "/rank/F_0_0_8_0_0/"
rc.is_show = true
rc.save

rc = RankCategory.new
rc.name = '主題餐廳'
rc.photo_url = 'null'
rc.code_number = "/rank/F_0_0_10_0_0/"
rc.is_show = true
rc.save


