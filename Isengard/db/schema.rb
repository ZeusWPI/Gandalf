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

ActiveRecord::Schema.define(version: 20131010193505) do

  create_table "access_levels", force: true do |t|
    t.string   "name"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "capacity"
  end

  add_index "access_levels", ["event_id"], name: "index_access_levels_on_event_id"

  create_table "events", force: true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "location"
    t.string   "website"
    t.text     "description"
    t.string   "organisation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "included_zones", force: true do |t|
    t.integer  "zone_id"
    t.integer  "access_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "included_zones", ["access_level_id"], name: "index_included_zones_on_access_level_id"
  add_index "included_zones", ["zone_id"], name: "index_included_zones_on_zone_id"

  create_table "people", force: true do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["username"], name: "index_people_on_username", unique: true

  create_table "periods", force: true do |t|
    t.datetime "starts"
    t.datetime "ends"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations", force: true do |t|
    t.integer  "barcode"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
  end

  add_index "registrations", ["event_id"], name: "index_registrations_on_event_id"

  create_table "role_names", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "role_names", ["name"], name: "index_role_names_on_name", unique: true

  create_table "roles", force: true do |t|
    t.integer  "person_id"
    t.integer  "event_id"
    t.integer  "role_name_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["event_id"], name: "index_roles_on_event_id"
  add_index "roles", ["person_id", "event_id", "role_name_id"], name: "index_roles_on_person_id_and_event_id_and_role_name_id", unique: true
  add_index "roles", ["person_id"], name: "index_roles_on_person_id"
  add_index "roles", ["role_name_id"], name: "index_roles_on_role_name_id"

  create_table "zone_accesses", force: true do |t|
    t.integer  "zone_id"
    t.integer  "period_id"
    t.integer  "registration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "zone_accesses", ["period_id"], name: "index_zone_accesses_on_period_id"
  add_index "zone_accesses", ["registration_id"], name: "index_zone_accesses_on_registration_id"
  add_index "zone_accesses", ["zone_id"], name: "index_zone_accesses_on_zone_id"

  create_table "zones", force: true do |t|
    t.string   "name"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "zones", ["event_id"], name: "index_zones_on_event_id"
  add_index "zones", ["name", "event_id"], name: "index_zones_on_name_and_event_id", unique: true

end
