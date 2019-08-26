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

ActiveRecord::Schema.define(version: 20190824010307) do

  create_table "access_levels", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "event_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "capacity",    limit: 4
    t.integer  "price",       limit: 4
    t.boolean  "has_comment"
    t.boolean  "hidden"
    t.string   "permit",      limit: 255, default: "everyone"
  end

  add_index "access_levels", ["event_id"], name: "index_access_levels_on_event_id", using: :btree

  create_table "access_levels_promos", id: false, force: :cascade do |t|
    t.integer "promo_id",        limit: 4, null: false
    t.integer "access_level_id", limit: 4, null: false
  end

  create_table "accesses", force: :cascade do |t|
    t.integer  "period_id",       limit: 4
    t.integer  "registration_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "access_level_id", limit: 4
  end

  add_index "accesses", ["access_level_id"], name: "index_accesses_on_access_level_id", using: :btree
  add_index "accesses", ["period_id"], name: "index_accesses_on_period_id", using: :btree
  add_index "accesses", ["registration_id"], name: "index_accesses_on_registration_id", using: :btree

  create_table "clubs", force: :cascade do |t|
    t.string   "full_name",     limit: 255
    t.string   "internal_name", limit: 255
    t.string   "display_name",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clubs_users", id: false, force: :cascade do |t|
    t.integer "club_id", limit: 4
    t.integer "user_id", limit: 4
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "enrolled_clubs_members", id: false, force: :cascade do |t|
    t.integer "club_id", limit: 4, null: false
    t.integer "user_id", limit: 4, null: false
  end

  add_index "enrolled_clubs_members", ["club_id"], name: "index_enrolled_clubs_members_on_club_id", using: :btree
  add_index "enrolled_clubs_members", ["user_id"], name: "index_enrolled_clubs_members_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name",                      limit: 255
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "location",                  limit: 255
    t.string   "website",                   limit: 255
    t.text     "description",               limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "registration_open_date"
    t.datetime "registration_close_date"
    t.string   "bank_number",               limit: 255
    t.boolean  "show_ticket_count",                       default: true
    t.string   "contact_email",             limit: 255
    t.string   "export_file_name",          limit: 255
    t.string   "export_content_type",       limit: 255
    t.integer  "export_file_size",          limit: 4
    t.datetime "export_updated_at"
    t.boolean  "show_statistics"
    t.string   "export_status",             limit: 255
    t.integer  "club_id",                   limit: 4
    t.boolean  "registration_open",                       default: true
    t.text     "signature",                 limit: 65535
    t.boolean  "registration_cancelable"
    t.string   "phone_number_state",        limit: 191,   default: "optional"
    t.boolean  "extra_info",                              default: false
    t.string   "comment_title",             limit: 191
    t.boolean  "show_telephone_disclaimer",               default: false
    t.boolean  "allow_plus_one"
    t.boolean  "can_add_club"
  end

  create_table "included_zones", force: :cascade do |t|
    t.integer  "zone_id",         limit: 4
    t.integer  "access_level_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "included_zones", ["access_level_id"], name: "index_included_zones_on_access_level_id", using: :btree
  add_index "included_zones", ["zone_id"], name: "index_included_zones_on_zone_id", using: :btree

  create_table "partners", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "email",                  limit: 255
    t.string   "authentication_token",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "event_id",               limit: 4
    t.integer  "access_level_id",        limit: 4
    t.boolean  "confirmed"
  end

  add_index "partners", ["access_level_id"], name: "index_partners_on_access_level_id", using: :btree
  add_index "partners", ["authentication_token"], name: "index_partners_on_authentication_token", using: :btree
  add_index "partners", ["reset_password_token"], name: "index_partners_on_reset_password_token", unique: true, using: :btree

  create_table "periods", force: :cascade do |t|
    t.datetime "starts"
    t.datetime "ends"
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id",   limit: 4
  end

  add_index "periods", ["event_id"], name: "index_periods_on_event_id", using: :btree

  create_table "promos", force: :cascade do |t|
    t.integer  "event_id",     limit: 4
    t.string   "code",         limit: 255
    t.integer  "limit",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sold_tickets", limit: 4,   default: 0
  end

  add_index "promos", ["event_id"], name: "index_promos_on_event_id", using: :btree

  create_table "registrations", force: :cascade do |t|
    t.string   "barcode",            limit: 255
    t.string   "lastname",           limit: 255
    t.string   "email",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id",           limit: 4
    t.integer  "paid",               limit: 4
    t.string   "student_number",     limit: 255
    t.integer  "price",              limit: 4
    t.datetime "checked_in_at"
    t.text     "comment",            limit: 65535
    t.string   "barcode_data",       limit: 255
    t.string   "payment_code",       limit: 255
    t.string   "phone_number",       limit: 191
    t.string   "title",              limit: 191
    t.string   "job_function",       limit: 191
    t.string   "admin_note",         limit: 191
    t.string   "firstname",          limit: 191
    t.boolean  "has_plus_one"
    t.string   "plus_one_title",     limit: 191
    t.string   "plus_one_firstname", limit: 191
    t.string   "plus_one_lastname",  limit: 191
    t.integer  "club_id",            limit: 4
    t.string   "payment_method",     limit: 191
    t.string   "payment_id",         limit: 191
    t.integer  "number_of_tickets",  limit: 4,     default: 1
    t.integer  "sequence_number",    limit: 4,     default: 1
  end

  add_index "registrations", ["event_id"], name: "index_registrations_on_event_id", using: :btree
  add_index "registrations", ["payment_code"], name: "index_registrations_on_payment_code", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",            limit: 255, default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",  limit: 255
    t.string   "last_sign_in_ip",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cas_givenname",       limit: 255
    t.string   "cas_surname",         limit: 255
    t.string   "cas_ugentStudentID",  limit: 255
    t.string   "cas_mail",            limit: 255
    t.string   "cas_uid",             limit: 255
    t.boolean  "admin"
    t.string   "email",               limit: 255
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      limit: 255,   null: false
    t.integer  "item_id",        limit: 4,     null: false
    t.string   "event",          limit: 255,   null: false
    t.string   "whodunnit",      limit: 255
    t.text     "object",         limit: 65535
    t.datetime "created_at"
    t.text     "object_changes", limit: 65535
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "zones", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "event_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "zones", ["event_id"], name: "index_zones_on_event_id", using: :btree
  add_index "zones", ["name", "event_id"], name: "index_zones_on_name_and_event_id", unique: true, using: :btree

end
