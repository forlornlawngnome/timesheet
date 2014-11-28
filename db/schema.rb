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

ActiveRecord::Schema.define(:version => 20141128190101) do

  create_table "forms", :force => true do |t|
    t.string   "name"
    t.boolean  "archive"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "forms_users", :force => true do |t|
    t.integer "user_id"
    t.integer "form_id"
  end

  add_index "forms_users", ["form_id"], :name => "index_forms_users_on_form_id"
  add_index "forms_users", ["user_id"], :name => "index_forms_users_on_user_id"

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "timelogs", :force => true do |t|
    t.integer  "user_id"
    t.datetime "timein"
    t.datetime "timeout"
    t.integer  "time_logged"
    t.datetime "updated_at"
  end

  add_index "timelogs", ["user_id"], :name => "index_timelogs_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "admin"
    t.string   "phone"
    t.string   "name_first"
    t.string   "name_last"
    t.string   "userid"
    t.integer  "school_id"
    t.boolean  "tools"
    t.boolean  "conduct"
    t.boolean  "basicSafety"
    t.string   "password_salt"
    t.string   "password_hash"
    t.boolean  "archive"
    t.string   "location"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
