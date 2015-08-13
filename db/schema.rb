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

ActiveRecord::Schema.define(version: 20150813222358) do

  create_table "app_settings", force: :cascade do |t|
    t.string   "key",        limit: 50
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_settings", ["key"], name: "index_app_settings_on_key"

  create_table "devices", force: :cascade do |t|
    t.string   "name"
    t.string   "key"
    t.string   "token"
    t.string   "model"
    t.string   "version"
    t.integer  "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "devices", ["key", "token"], name: "index_devices_on_key_and_token", unique: true
  add_index "devices", ["owner_id"], name: "index_devices_on_owner_id"

  create_table "measures", force: :cascade do |t|
    t.float    "value"
    t.datetime "taken_at"
    t.integer  "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "metric_id"
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
    t.string   "NO2"
    t.string   "NO3"
    t.string   "GH"
    t.string   "PH"
    t.string   "KH"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "strips", ["device_id"], name: "index_strips_on_device_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
