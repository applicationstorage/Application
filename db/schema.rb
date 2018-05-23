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

ActiveRecord::Schema.define(version: 20180507080842) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "disposeds", force: :cascade do |t|
    t.date "date_disposed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "item_id"
    t.index ["item_id"], name: "index_disposeds_on_item_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.string "item_name"
    t.string "item_category"
    t.integer "total_stock"
    t.integer "total_available"
    t.string "loan_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "model_type"
    t.string "serial_equipment_number"
    t.float "purchase_price"
    t.date "purchase_date"
    t.string "item_location"
    t.boolean "is_research_project"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "inventory_id"
    t.boolean "disposed_of"
    t.string "loan_token"
    t.boolean "in_use"
    t.bigint "research_project_id"
    t.index ["inventory_id"], name: "index_items_on_inventory_id"
    t.index ["research_project_id"], name: "index_items_on_research_project_id"
    t.index ["serial_equipment_number"], name: "index_items_on_serial_equipment_number", unique: true
  end

  create_table "loan_histories", force: :cascade do |t|
    t.date "returned_on"
    t.boolean "late"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "item_id"
    t.bigint "loan_id"
    t.index ["item_id"], name: "index_loan_histories_on_item_id"
    t.index ["loan_id"], name: "index_loan_histories_on_loan_id"
  end

  create_table "loans", force: :cascade do |t|
    t.date "request_date"
    t.date "due_date"
    t.boolean "approved"
    t.boolean "returned"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount_requested"
    t.string "loan_token"
    t.bigint "inventory_id"
    t.string "requestee_name"
    t.string "requestee_email"
    t.text "reason_for_loan"
    t.boolean "in_basket"
    t.index ["loan_token"], name: "index_loans_on_loan_token", unique: true
  end

  create_table "research_projects", force: :cascade do |t|
    t.date "end_of_project"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "researcher_name"
    t.string "researcher_email"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "uid"
    t.string "mail"
    t.string "ou"
    t.string "dn"
    t.string "sn"
    t.string "givenname"
    t.boolean "manager"
    t.index ["email"], name: "index_users_on_email"
    t.index ["username"], name: "index_users_on_username"
  end

  add_foreign_key "disposeds", "items"
  add_foreign_key "items", "inventories"
  add_foreign_key "items", "loans", column: "loan_token", primary_key: "loan_token"
  add_foreign_key "items", "research_projects"
  add_foreign_key "loan_histories", "items"
  add_foreign_key "loan_histories", "loans"
end
