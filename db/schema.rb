# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130602131232) do

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.string   "code_name"
    t.integer  "area_num"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "photo_url"
    t.string   "code_number"
    t.integer  "max_page_num"
    t.boolean  "is_show"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "notes", :force => true do |t|
    t.string   "title"
    t.string   "author"
    t.string   "pic_url"
    t.string   "pub_date"
    t.string   "ipeen_link"
    t.string   "blog_link"
    t.integer  "restaurant_id"
    t.boolean  "is_show"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "notes", ["restaurant_id"], :name => "index_notes_on_restaurant_id"

  create_table "rank_categories", :force => true do |t|
    t.string   "name"
    t.string   "photo_url"
    t.string   "code_number"
    t.boolean  "is_show"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "recommands", :force => true do |t|
    t.integer  "area_id"
    t.string   "name"
    t.integer  "grade_food"
    t.integer  "grade_service"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "restaurant_category_rank_ships", :force => true do |t|
    t.integer  "restaurant_id"
    t.integer  "rank_category_id"
    t.integer  "area_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "restaurant_category_rank_ships", ["area_id"], :name => "index_restaurant_category_rank_ships_on_area_id"
  add_index "restaurant_category_rank_ships", ["rank_category_id"], :name => "index_restaurant_category_rank_ships_on_rank_category_id"
  add_index "restaurant_category_rank_ships", ["restaurant_id"], :name => "index_restaurant_category_rank_ships_on_restaurant_id"

  create_table "restaurant_type_ships", :force => true do |t|
    t.integer  "restaurant_id"
    t.integer  "type_id"
    t.integer  "area_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "restaurant_type_ships", ["area_id"], :name => "index_restaurant_type_ships_on_area_id"
  add_index "restaurant_type_ships", ["restaurant_id"], :name => "index_restaurant_type_ships_on_restaurant_id"
  add_index "restaurant_type_ships", ["type_id"], :name => "index_restaurant_type_ships_on_type_id"

  create_table "restaurants", :force => true do |t|
    t.string   "name"
    t.string   "pic_url"
    t.string   "ipeen_link"
    t.string   "grade_food"
    t.string   "grade_service"
    t.string   "grade_ambiance"
    t.string   "price"
    t.string   "open_time"
    t.string   "rest_date"
    t.string   "address"
    t.string   "phone"
    t.integer  "rate_num"
    t.text     "introduction"
    t.string   "official_link"
    t.string   "recommand_dish"
    t.decimal  "x_lat",              :precision => 15, :scale => 10
    t.decimal  "y_long",             :precision => 15, :scale => 10
    t.integer  "category_id"
    t.integer  "second_category_id"
    t.integer  "area_id"
    t.boolean  "is_show"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  add_index "restaurants", ["area_id"], :name => "index_restaurants_on_area_id"
  add_index "restaurants", ["name"], :name => "index_restaurants_on_name"

  create_table "second_categories", :force => true do |t|
    t.string   "name"
    t.string   "code_number"
    t.boolean  "is_show"
    t.integer  "max_page_num"
    t.integer  "category_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "selected_notes", :force => true do |t|
    t.integer  "note_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "selected_restaurants", :force => true do |t|
    t.integer  "restaurant_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "types", :force => true do |t|
    t.string   "name"
    t.string   "code_number"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
