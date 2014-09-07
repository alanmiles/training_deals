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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140906003601) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "businesses", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.text     "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "hide_address",   default: false
    t.string   "phone"
    t.string   "alt_phone"
    t.string   "email"
    t.string   "website"
    t.string   "logo"
    t.string   "image"
    t.boolean  "inactive",       default: false
    t.datetime "inactive_from"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "businesses", ["country", "city", "name"], name: "index_businesses_on_country_and_city_and_name", unique: true, using: :btree

  create_table "categories", force: true do |t|
    t.string   "description"
    t.integer  "genre_id"
    t.integer  "created_by",  default: 1
    t.integer  "status",      default: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["genre_id", "description"], name: "index_categories_on_genre_id_and_description", using: :btree

  create_table "content_lengths", force: true do |t|
    t.string   "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "content_lengths", ["description"], name: "index_content_lengths_on_description", using: :btree

  create_table "durations", force: true do |t|
    t.string   "time_unit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  add_index "durations", ["time_unit"], name: "index_durations_on_time_unit", using: :btree

  create_table "events", force: true do |t|
    t.integer  "product_id"
    t.date     "start_date"
    t.date     "end_date"
    t.time     "start_time"
    t.time     "finish_time"
    t.string   "attendance_days"
    t.string   "time_of_day"
    t.string   "location"
    t.string   "note"
    t.integer  "created_by"
    t.boolean  "cancelled",                                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price",            precision: 8, scale: 2
    t.integer  "places_available",                         default: 0
    t.integer  "places_sold",                              default: 0
  end

  add_index "events", ["product_id", "start_date"], name: "index_events_on_product_id_and_start_date", unique: true, using: :btree

  create_table "genres", force: true do |t|
    t.string   "description"
    t.integer  "position"
    t.integer  "created_by",  default: 1
    t.integer  "status",      default: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "genres", ["description"], name: "index_genres_on_description", using: :btree

  create_table "ownerships", force: true do |t|
    t.integer  "business_id"
    t.integer  "user_id"
    t.string   "email_address"
    t.boolean  "contactable",   default: false
    t.string   "phone"
    t.integer  "position"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ownerships", ["business_id", "user_id"], name: "index_ownerships_on_business_id_and_user_id", unique: true, using: :btree

  create_table "products", force: true do |t|
    t.integer  "business_id"
    t.string   "title"
    t.string   "ref_code"
    t.integer  "topic_id"
    t.string   "qualification"
    t.integer  "training_method_id"
    t.integer  "duration_id"
    t.decimal  "duration_number",    precision: 6, scale: 2
    t.integer  "content_length_id"
    t.decimal  "content_number",     precision: 6, scale: 2
    t.string   "currency"
    t.decimal  "standard_cost",      precision: 8, scale: 2
    t.text     "content"
    t.text     "outcome"
    t.boolean  "current",                                    default: true
    t.string   "image"
    t.string   "web_link"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["business_id", "topic_id", "title"], name: "index_products_on_business_id_and_topic_id_and_title", unique: true, using: :btree
  add_index "products", ["business_id"], name: "index_products_on_business_id", using: :btree
  add_index "products", ["topic_id"], name: "index_products_on_topic_id", using: :btree

  create_table "topics", force: true do |t|
    t.string   "description"
    t.integer  "category_id"
    t.integer  "created_by",  default: 1
    t.integer  "status",      default: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "topics", ["category_id", "description"], name: "index_topics_on_category_id_and_description", using: :btree

  create_table "training_methods", force: true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.boolean  "event",       default: false
  end

  add_index "training_methods", ["description"], name: "index_training_methods_on_description", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
    t.boolean  "vendor",          default: false
    t.string   "location"
    t.string   "city"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
