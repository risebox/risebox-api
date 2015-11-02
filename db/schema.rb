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

ActiveRecord::Schema.define(version: 20151102200053) do

  create_table "app_settings", force: :cascade do |t|
    t.string   "key",        limit: 50
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_settings", ["key"], name: "index_app_settings_on_key"

  create_table "device_permissions", force: :cascade do |t|
    t.integer  "device_id",  null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "device_permissions", ["device_id", "user_id"], name: "index_device_permissions_on_device_id_and_user_id", unique: true

  create_table "device_settings", force: :cascade do |t|
    t.integer  "device_id"
    t.string   "key"
    t.string   "data_type"
    t.float    "value"
    t.datetime "changed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "device_settings", ["device_id", "changed_at"], name: "index_device_settings_on_device_id_and_changed_at"
  add_index "device_settings", ["device_id", "key"], name: "index_device_settings_on_device_id_and_key"
  add_index "device_settings", ["device_id"], name: "index_device_settings_on_device_id"

  create_table "devices", force: :cascade do |t|
    t.string   "name"
    t.string   "key"
    t.string   "model"
    t.string   "version"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.datetime "settings_queried_at"
  end

  add_index "devices", ["key"], name: "index_devices_on_key"

  create_table "log_entries", force: :cascade do |t|
    t.integer  "level"
    t.text     "body"
    t.integer  "device_id"
    t.datetime "logged_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "log_entries", ["device_id", "logged_at"], name: "index_log_entries_on_device_id_and_logged_at"
  add_index "log_entries", ["device_id"], name: "index_log_entries_on_device_id"

  create_table "measures", force: :cascade do |t|
    t.float    "value"
    t.datetime "taken_at"
    t.integer  "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "metric_id"
    t.string   "origin"
  end

  add_index "measures", ["device_id"], name: "index_measures_on_device_id"
  add_index "measures", ["metric_id"], name: "index_measures_on_metric_id"

  create_table "metric_statuses", force: :cascade do |t|
    t.integer  "device_id"
    t.integer  "metric_id"
    t.float    "value"
    t.datetime "taken_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.float    "limit_min"
    t.float    "limit_max"
    t.string   "level"
    t.string   "light"
    t.string   "description"
  end

  add_index "metric_statuses", ["device_id", "metric_id"], name: "index_metric_statuses_on_device_id_and_metric_id", unique: true
  add_index "metric_statuses", ["device_id"], name: "index_metric_statuses_on_device_id"

  create_table "metrics", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "unit"
    t.integer  "display_order"
  end

  add_index "metrics", ["code"], name: "index_metrics_on_code"

  create_table "push_tokens", force: :cascade do |t|
    t.string   "token"
    t.integer  "registration_id"
    t.datetime "registered_at"
    t.string   "platform"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "push_tokens", ["registration_id"], name: "index_push_tokens_on_registration_id"
  add_index "push_tokens", ["token"], name: "index_push_tokens_on_token"

  create_table "registrations", force: :cascade do |t|
    t.integer  "device_id"
    t.integer  "user_id"
    t.string   "token"
    t.string   "origin"
    t.datetime "made_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "registrations", ["token"], name: "index_registrations_on_token"

  create_table "strips", force: :cascade do |t|
    t.integer  "device_id"
    t.datetime "tested_at"
    t.datetime "computed_at"
    t.string   "model"
    t.string   "upload_key"
    t.string   "no2"
    t.string   "no3"
    t.string   "gh"
    t.string   "ph"
    t.string   "kh"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "strips", ["device_id"], name: "index_strips_on_device_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "api_token"
    t.boolean  "admin",                  default: false
    t.boolean  "human",                  default: true
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["human"], name: "index_users_on_human"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
