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

ActiveRecord::Schema.define(version: 20140712233727) do

  create_table "account_logs", force: true do |t|
    t.integer  "account_id"
    t.float    "change"
    t.integer  "source"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts", force: true do |t|
    t.integer  "user_id"
    t.decimal  "available"
    t.decimal  "frozen_value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_tax_time"
  end

  create_table "bets", force: true do |t|
    t.integer  "user_id"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gamble_id"
    t.integer  "gamble_item_id"
  end

  create_table "comments", force: true do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "role",                        default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "gamble_items", force: true do |t|
    t.integer  "gamble_id"
    t.string   "description"
    t.boolean  "win"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "odds"
  end

  create_table "gambles", force: true do |t|
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gamble_type"
    t.integer  "target_id"
  end

  create_table "games", force: true do |t|
    t.datetime "date"
    t.integer  "host_id"
    t.integer  "guest_id"
    t.integer  "host_score"
    t.integer  "guest_score"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "balance"
    t.integer  "gamble_id"
    t.integer  "bet_for_win_id"
    t.integer  "bet_for_draw_id"
    t.integer  "bet_for_lose_id"
  end

  create_table "ranks", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "rank"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.string   "external_link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "roles_mask"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
