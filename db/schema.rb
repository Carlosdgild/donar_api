# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_07_26_062207) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "donations", force: :cascade do |t|
    t.decimal "amount"
    t.string "currency"
    t.string "description"
    t.bigint "user_id"
    t.bigint "payment_id"
    t.integer "status"
    t.datetime "deleted_at"
    t.string "instructions"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "login_activity_id"
    t.index ["created_at"], name: "index_donations_on_created_at"
    t.index ["login_activity_id"], name: "index_donations_on_login_activity_id"
    t.index ["payment_id"], name: "index_donations_on_payment_id"
    t.index ["user_id"], name: "index_donations_on_user_id"
  end

  create_table "login_activities", force: :cascade do |t|
    t.string "user_agent"
    t.string "address_ip"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_login_activities_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount"
    t.string "currency"
    t.string "charge_id"
    t.string "payment_method"
    t.string "fingerprint"
    t.string "card_last_number"
    t.string "brand"
    t.integer "status"
    t.string "receipt_url"
    t.json "error_info"
    t.datetime "deleted_at"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name", null: false
    t.string "last_name", null: false
    t.integer "role", default: 0
    t.integer "signup_status", default: 0
    t.datetime "deleted_at"
    t.json "tokens"
    t.string "api_id"
    t.string "api_key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "donations", "login_activities"
  add_foreign_key "donations", "payments"
  add_foreign_key "donations", "users"
  add_foreign_key "login_activities", "users"
  add_foreign_key "payments", "users"
end
