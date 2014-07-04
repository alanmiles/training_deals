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

ActiveRecord::Schema.define(version: 20140703224544) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "genres", force: true do |t|
    t.string   "description"
    t.integer  "position"
    t.integer  "created_by",  default: 1
    t.integer  "status",      default: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "genres", ["description"], name: "index_genres_on_description", using: :btree

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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
