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

ActiveRecord::Schema.define(version: 20180101092546) do

  create_table "chains", force: :cascade do |t|
    t.string   "block",      limit: 255
    t.string   "currency",   limit: 255
    t.string   "title",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "day_bars", force: :cascade do |t|
    t.integer "chain_id",    limit: 8
    t.float   "open",        limit: 24
    t.float   "close",       limit: 24
    t.float   "high",        limit: 24
    t.float   "low",         limit: 24
    t.float   "volume",      limit: 24
    t.float   "base_volume", limit: 24
    t.decimal "time_stamp",             precision: 15
  end

  create_table "day_indicators", force: :cascade do |t|
    t.integer "chain_id",   limit: 8
    t.integer "day_bar_id", limit: 8
    t.float   "ma5",        limit: 24
    t.float   "ma10",       limit: 24
    t.float   "macd_diff",  limit: 24
    t.float   "macd_dea",   limit: 24
    t.float   "macd_fast",  limit: 24
    t.float   "macd_slow",  limit: 24
  end

  create_table "markets", force: :cascade do |t|
    t.integer  "chain_id",    limit: 8
    t.float    "bid",         limit: 24
    t.float    "ask",         limit: 24
    t.float    "high",        limit: 24
    t.float    "low",         limit: 24
    t.decimal  "open_buy",               precision: 10
    t.decimal  "open_sell",              precision: 10
    t.float    "prev_day",    limit: 24
    t.float    "volume",      limit: 24
    t.float    "base_volume", limit: 24
    t.decimal  "time_stamp",             precision: 15
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "markets", ["time_stamp"], name: "index_markets_on_time_stamp", using: :btree

  create_table "min30_indicators", force: :cascade do |t|
    t.integer "chain_id",   limit: 8
    t.integer "market_id",  limit: 8
    t.float   "last_price", limit: 24
    t.float   "ma5",        limit: 24
    t.float   "ma15",       limit: 24
    t.float   "macd_fast",  limit: 24
    t.float   "macd_slow",  limit: 24
    t.float   "macd_dea",   limit: 24
    t.float   "macd_diff",  limit: 24
    t.decimal "time_stamp",            precision: 15
  end

  add_index "min30_indicators", ["time_stamp"], name: "index_min30_indicators_on_time_stamp", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "role",                   limit: 4,   default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
