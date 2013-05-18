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

ActiveRecord::Schema.define(:version => 20130517063203) do

  create_table "area_categoryships", :force => true do |t|
    t.integer  "area_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "floor"
    t.string   "name"
    t.string   "info"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notes", :force => true do |t|
    t.string   "title"
    t.string   "intro"
    t.string   "pic_url"
    t.string   "link"
    t.integer  "restaurant_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "notes", ["restaurant_id"], :name => "index_notes_on_restaurant_id"

  create_table "restaurant_category_ships", :force => true do |t|
    t.integer  "restaurant_id"
    t.integer  "category_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "restaurant_type_ships", :force => true do |t|
    t.integer  "restaurant_id"
    t.integer  "type_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "restaurant_type_ships", ["restaurant_id"], :name => "index_restaurant_type_ships_on_restaurant_id"
  add_index "restaurant_type_ships", ["type_id"], :name => "index_restaurant_type_ships_on_type_id"

  create_table "restaurants", :force => true do |t|
    t.string   "name"
    t.string   "eztable_link"
    t.string   "grade_food"
    t.string   "grade_ambiance"
    t.string   "grade_service"
    t.string   "pic_url"
    t.string   "address"
    t.text     "open_time"
    t.string   "official_link"
    t.string   "eat_type"
    t.string   "price"
    t.text     "traffic"
    t.text     "introduction"
    t.integer  "area_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "restaurants", ["area_id"], :name => "index_restaurants_on_area_id"
  add_index "restaurants", ["name"], :name => "index_restaurants_on_name"

  create_table "types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
