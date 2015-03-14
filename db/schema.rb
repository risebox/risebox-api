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

ActiveRecord::Schema.define(version: 20150314153934) do

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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "metric_statuses", ["device_id", "metric_id"], name: "index_metric_statuses_on_device_id_and_metric_id", unique: true
  add_index "metric_statuses", ["device_id"], name: "index_metric_statuses_on_device_id"

  create_table "metrics", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "unit"
  end

  add_index "metrics", ["code"], name: "index_metrics_on_code"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
