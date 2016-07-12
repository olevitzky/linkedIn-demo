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

ActiveRecord::Schema.define(version: 20160712120918) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "educations", force: :cascade do |t|
    t.integer  "profile_id"
    t.string   "name"
    t.integer  "first_year"
    t.integer  "final_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "experiences", force: :cascade do |t|
    t.integer  "profile_id"
    t.string   "company"
    t.string   "title"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.string   "uuid"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "full_name"
    t.string   "title"
    t.string   "current_position"
    t.text     "summary"
    t.text     "skills",           default: [],               array: true
    t.float    "score",            default: 0.0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "state"
  end

  add_index "profiles", ["current_position"], name: "index_profiles_on_current_position", using: :btree
  add_index "profiles", ["full_name"], name: "index_profiles_on_full_name", using: :btree
  add_index "profiles", ["skills"], name: "index_profiles_on_skills", using: :btree
  add_index "profiles", ["summary"], name: "index_profiles_on_summary", using: :btree
  add_index "profiles", ["title"], name: "index_profiles_on_title", using: :btree
  add_index "profiles", ["uuid"], name: "index_profiles_on_uuid", using: :btree

end
