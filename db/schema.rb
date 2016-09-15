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

ActiveRecord::Schema.define(version: 20160914125410) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "submission_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "comments", ["submission_id"], name: "index_comments_on_submission_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "rates", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "submission_id"
    t.integer  "user_id"
    t.integer  "value"
  end

  add_index "rates", ["submission_id"], name: "index_rates_on_submission_id", using: :btree
  add_index "rates", ["user_id"], name: "index_rates_on_user_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.integer  "accepted_threshold"
    t.integer  "waitlist_threshold"
    t.integer  "required_rates_num"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.datetime "beginning_of_preparation_period"
    t.datetime "beginning_of_registration_period"
    t.datetime "beginning_of_closed_period"
    t.date     "event_start_date",                 null: false
    t.date     "event_end_date",                   null: false
    t.string   "event_url",                        null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.string   "full_name"
    t.string   "email"
    t.integer  "age"
    t.string   "codecademy_username"
    t.text     "description"
    t.string   "english"
    t.string   "operating_system"
    t.boolean  "first_time"
    t.text     "goals"
    t.text     "problems"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "html"
    t.string   "css"
    t.string   "js"
    t.string   "ror"
    t.string   "db"
    t.string   "programming_others"
    t.boolean  "rejected",            default: false
    t.string   "codecademy_status",   default: "pending"
  end

  add_index "submissions", ["email"], name: "index_submissions_on_email", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "nickname",                        null: false
  end

  add_foreign_key "comments", "submissions"
  add_foreign_key "comments", "users"
  add_foreign_key "rates", "submissions"
  add_foreign_key "rates", "users"
end
