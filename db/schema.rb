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

ActiveRecord::Schema.define(version: 2022_05_02_101542) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", id: :serial, force: :cascade do |t|
    t.integer "question_id"
    t.integer "submission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "choice"
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["submission_id"], name: "index_answers_on_submission_id"
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "body"
    t.integer "submission_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["submission_id"], name: "index_comments_on_submission_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rates", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "submission_id"
    t.integer "user_id"
    t.integer "value"
    t.index ["submission_id"], name: "index_rates_on_submission_id"
    t.index ["user_id"], name: "index_rates_on_user_id"
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.integer "required_rates_num", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "beginning_of_preparation_period", null: false
    t.datetime "beginning_of_registration_period", null: false
    t.datetime "beginning_of_closed_period", null: false
    t.date "event_start_date", null: false
    t.date "event_end_date", null: false
    t.string "event_url", null: false
    t.integer "available_spots", null: false
    t.integer "days_to_confirm_invitation", null: false
    t.string "event_venue"
    t.boolean "invitation_process_started", default: false, null: false
    t.text "contact_email"
  end

  create_table "submissions", id: :serial, force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.text "description"
    t.string "english"
    t.string "operating_system"
    t.boolean "first_time"
    t.text "goals"
    t.text "problems"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "rejected", default: false
    t.string "invitation_token"
    t.datetime "invitation_token_created_at"
    t.boolean "invitation_confirmed", default: false
    t.boolean "adult", default: false
    t.string "gender"
    t.datetime "bad_news_sent_at"
    t.index ["email"], name: "index_submissions_on_email", unique: true
    t.index ["invitation_token"], name: "index_submissions_on_invitation_token"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "nickname", null: false
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "submissions"
  add_foreign_key "comments", "submissions"
  add_foreign_key "comments", "users"
  add_foreign_key "rates", "submissions"
  add_foreign_key "rates", "users"
end
