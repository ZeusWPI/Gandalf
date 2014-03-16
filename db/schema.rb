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

ActiveRecord::Schema.define(version: 20140316194936) do

  create_table "access_levels", force: true do |t|
    t.string   "name"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "capacity"
    t.integer  "price"
    t.boolean  "public",      default: true
    t.boolean  "has_comment"
    t.boolean  "hidden"
    t.boolean  "member_only"
  end

  add_index "access_levels", ["event_id"], name: "index_access_levels_on_event_id"

  create_table "accesses", force: true do |t|
    t.integer  "period_id"
    t.integer  "registration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "access_level_id"
  end

  add_index "accesses", ["access_level_id"], name: "index_accesses_on_access_level_id"
  add_index "accesses", ["period_id"], name: "index_accesses_on_period_id"
  add_index "accesses", ["registration_id"], name: "index_accesses_on_registration_id"

  create_table "clubs", force: true do |t|
    t.string   "full_name"
    t.string   "internal_name"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clubs_users", id: false, force: true do |t|
    t.integer "club_id"
    t.integer "user_id"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "enrolled_clubs_members", id: false, force: true do |t|
    t.integer "club_id", null: false
    t.integer "user_id", null: false
  end

  add_index "enrolled_clubs_members", ["club_id"], name: "index_enrolled_clubs_members_on_club_id"
  add_index "enrolled_clubs_members", ["user_id"], name: "index_enrolled_clubs_members_on_user_id"

  create_table "events", force: true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "location"
    t.string   "website"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "registration_open_date"
    t.datetime "registration_close_date"
    t.string   "bank_number"
    t.boolean  "show_ticket_count",       default: true
    t.string   "contact_email"
    t.string   "export_file_name"
    t.string   "export_content_type"
    t.integer  "export_file_size"
    t.datetime "export_updated_at"
    t.boolean  "show_statistics"
    t.string   "export_status"
    t.integer  "club_id"
    t.boolean  "registration_open",       default: true
  end

  create_table "included_zones", force: true do |t|
    t.integer  "zone_id"
    t.integer  "access_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "included_zones", ["access_level_id"], name: "index_included_zones_on_access_level_id"
  add_index "included_zones", ["zone_id"], name: "index_included_zones_on_zone_id"

  create_table "partners", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "event_id"
    t.integer  "access_level_id"
    t.boolean  "confirmed"
  end

  add_index "partners", ["access_level_id"], name: "index_partners_on_access_level_id"
  add_index "partners", ["authentication_token"], name: "index_partners_on_authentication_token"
  add_index "partners", ["reset_password_token"], name: "index_partners_on_reset_password_token", unique: true

  create_table "periods", force: true do |t|
    t.datetime "starts"
    t.datetime "ends"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
  end

  add_index "periods", ["event_id"], name: "index_periods_on_event_id"

  create_table "registrations", force: true do |t|
    t.string   "barcode"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "paid"
    t.string   "student_number"
    t.integer  "price"
    t.datetime "checked_in_at"
    t.text     "comment"
    t.string   "barcode_data"
    t.string   "payment_code"
  end

  add_index "registrations", ["event_id"], name: "index_registrations_on_event_id"
  add_index "registrations", ["payment_code"], name: "index_registrations_on_payment_code", unique: true

  create_table "users", force: true do |t|
    t.string   "username",            default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cas_givenname"
    t.string   "cas_surname"
    t.string   "cas_ugentStudentID"
    t.string   "cas_mail"
    t.string   "cas_uid"
    t.boolean  "admin"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

  create_table "zones", force: true do |t|
    t.string   "name"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "zones", ["event_id"], name: "index_zones_on_event_id"
  add_index "zones", ["name", "event_id"], name: "index_zones_on_name_and_event_id", unique: true

end
