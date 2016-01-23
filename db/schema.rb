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

ActiveRecord::Schema.define(version: 20160123191805) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "forms", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.boolean  "archive"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.boolean  "required"
  end

  create_table "forms_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "form_id"
  end

  add_index "forms_users", ["form_id"], name: "index_forms_users_on_form_id", using: :btree
  add_index "forms_users", ["user_id"], name: "index_forms_users_on_user_id", using: :btree

  create_table "hour_exceptions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "submitter",       limit: 255
    t.date     "date_applicable"
    t.date     "date_sent"
    t.string   "reason",          limit: 255
    t.integer  "year_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "week_id"
    t.boolean  "made_up_hours"
  end

  add_index "hour_exceptions", ["user_id"], name: "index_hour_exceptions_on_user_id", using: :btree
  add_index "hour_exceptions", ["year_id"], name: "index_hour_exceptions_on_year_id", using: :btree

  create_table "hour_overrides", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "year_id"
    t.integer  "hours_required"
    t.text     "reason"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "hour_overrides", ["user_id"], name: "index_hour_overrides_on_user_id", using: :btree
  add_index "hour_overrides", ["year_id"], name: "index_hour_overrides_on_year_id", using: :btree

  create_table "schools", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "timelogs", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "timein"
    t.datetime "timeout"
    t.integer  "time_logged"
    t.datetime "updated_at"
    t.integer  "year_id"
    t.integer  "week_id"
  end

  add_index "timelogs", ["user_id"], name: "index_timelogs_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.boolean  "admin"
    t.string   "phone",                  limit: 255
    t.string   "name_first",             limit: 255
    t.string   "name_last",              limit: 255
    t.string   "userid",                 limit: 255
    t.integer  "school_id"
    t.boolean  "tools"
    t.boolean  "conduct"
    t.boolean  "basicSafety"
    t.string   "password_salt",          limit: 255
    t.string   "password_hash",          limit: 255
    t.boolean  "archive"
    t.string   "location",               limit: 255
    t.string   "gender",                 limit: 255
    t.string   "graduation_year",        limit: 255
    t.boolean  "student_leader"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "week_exceptions", force: :cascade do |t|
    t.date     "date"
    t.decimal  "weight"
    t.text     "reason"
    t.integer  "year_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "week_id"
  end

  add_index "week_exceptions", ["year_id"], name: "index_week_exceptions_on_year_id", using: :btree

  create_table "weeks", force: :cascade do |t|
    t.date     "week_start"
    t.date     "week_end"
    t.string   "season"
    t.integer  "year_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "weeks", ["year_id"], name: "index_weeks_on_year_id", using: :btree

  create_table "years", force: :cascade do |t|
    t.date     "year_start"
    t.date     "year_end"
    t.date     "build_season_start"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.date     "preseason_start"
  end

  add_foreign_key "weeks", "years"
end
