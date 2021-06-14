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

ActiveRecord::Schema.define(version: 2021_06_14_104112) do

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "avatar"
    t.string "display_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "user_id", null: false
    t.string "content", null: false
    t.integer "parent_id"
    t.integer "reply_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "experts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "company_name"
    t.string "sector"
    t.float "rank"
    t.float "success_rate"
    t.float "average_return"
    t.string "display_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follow_experts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "expert_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follow_stocks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "stock_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_users", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "recipient_id", null: false
    t.boolean "read", null: false
    t.integer "stock_id", null: false
    t.string "notiable_type"
    t.integer "notiable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer "expert_id", null: false
    t.integer "stock_id", null: false
    t.integer "position", null: false
    t.integer "target_price", null: false
    t.text "content", null: false
    t.string "display_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "price_pasts", force: :cascade do |t|
    t.integer "stock_id", null: false
    t.datetime "month", null: false
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.integer "category_id", null: false
    t.string "code", null: false
    t.string "company_name", null: false
    t.string "exchange_name", null: false
    t.integer "current_price", null: false
    t.integer "price_forecast_low"
    t.integer "price_forecast_average"
    t.integer "price_forecast_high"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "avatar"
    t.string "email", null: false
    t.string "password"
    t.integer "account_type", default: 0, null: false
    t.string "display_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.integer "stock_id", null: false
    t.integer "user_id", null: false
    t.integer "vote", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
