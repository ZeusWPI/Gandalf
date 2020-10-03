# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_03_093227) do

  create_table "access_levels", force: :cascade do |t|
    t.string "name"
    t.integer "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "capacity"
    t.integer "price"
    t.boolean "has_comment"
    t.boolean "hidden"
    t.string "permit", default: "everyone"
    t.index ["event_id"], name: "index_access_levels_on_event_id"
  end

  create_table "access_levels_promos", id: false, force: :cascade do |t|
    t.integer "promo_id", null: false
    t.integer "access_level_id", null: false
  end

  create_table "accesses", force: :cascade do |t|
    t.integer "period_id"
    t.integer "registration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "access_level_id"
    t.index ["access_level_id"], name: "index_accesses_on_access_level_id"
    t.index ["period_id"], name: "index_accesses_on_period_id"
    t.index ["registration_id"], name: "index_accesses_on_registration_id"
  end

  create_table "clubs", force: :cascade do |t|
    t.string "full_name"
    t.string "internal_name"
    t.string "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clubs_users", id: false, force: :cascade do |t|
    t.integer "club_id"
    t.integer "user_id"
  end

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

  create_table "enrolled_clubs_members", id: false, force: :cascade do |t|
    t.integer "club_id", null: false
    t.integer "user_id", null: false
    t.index ["club_id"], name: "index_enrolled_clubs_members_on_club_id"
    t.index ["user_id"], name: "index_enrolled_clubs_members_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "location"
    t.string "website"
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "registration_open_date"
    t.datetime "registration_close_date"
    t.string "bank_number"
    t.boolean "show_ticket_count", default: true
    t.string "contact_email"
    t.string "export_file_name"
    t.string "export_content_type"
    t.integer "export_file_size"
    t.datetime "export_updated_at"
    t.boolean "show_statistics"
    t.string "export_status"
    t.integer "club_id"
    t.boolean "registration_open", default: true
    t.text "signature"
  end

  create_table "included_zones", force: :cascade do |t|
    t.integer "zone_id"
    t.integer "access_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["access_level_id"], name: "index_included_zones_on_access_level_id"
    t.index ["zone_id"], name: "index_included_zones_on_zone_id"
  end

  create_table "partners", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "event_id"
    t.integer "access_level_id"
    t.boolean "confirmed"
    t.index ["access_level_id"], name: "index_partners_on_access_level_id"
    t.index ["authentication_token"], name: "index_partners_on_authentication_token"
    t.index ["reset_password_token"], name: "index_partners_on_reset_password_token", unique: true
  end

  create_table "periods", force: :cascade do |t|
    t.datetime "starts"
    t.datetime "ends"
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "event_id"
    t.index ["event_id"], name: "index_periods_on_event_id"
  end

  create_table "promos", force: :cascade do |t|
    t.integer "event_id"
    t.string "code"
    t.integer "limit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "sold_tickets", default: 0
    t.index ["event_id"], name: "index_promos_on_event_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.string "barcode"
    t.string "name"
    t.string "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "event_id"
    t.integer "paid"
    t.string "student_number"
    t.integer "price"
    t.datetime "checked_in_at"
    t.text "comment"
    t.string "barcode_data"
    t.string "payment_code"
    t.index ["event_id"], name: "index_registrations_on_event_id"
    t.index ["payment_code"], name: "index_registrations_on_payment_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "cas_givenname"
    t.string "cas_surname"
    t.string "cas_ugentStudentID"
    t.string "cas_mail"
    t.string "cas_uid"
    t.boolean "admin"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "zones", force: :cascade do |t|
    t.string "name"
    t.integer "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["event_id"], name: "index_zones_on_event_id"
    t.index ["name", "event_id"], name: "index_zones_on_name_and_event_id", unique: true
  end

end
