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

ActiveRecord::Schema.define(version: 2021_06_11_055346) do

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "experts", force: :cascade do |t|
    t.integer "user_id"
    t.string "company_name"
    t.string "sector"
    t.float "rank"
    t.float "success_rate"
    t.float "average_return"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follow_experts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "expert_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follow_stocks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "stock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_users", force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer "expert_id"
    t.integer "stock_id"
    t.integer "position"
    t.integer "target_price"
    t.integer "ratings"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.integer "category_id"
    t.string "code"
    t.string "company_name"
    t.string "exchange_name"
    t.integer "current_price"
    t.json "price_past"
    t.integer "price_forecast_low"
    t.integer "price_forecast_average"
    t.integer "price_forecast_high"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "avatar"
    t.string "email"
    t.string "password"
    t.integer "account_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
