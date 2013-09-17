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

ActiveRecord::Schema.define(version: 20130917143822) do

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

  create_table "people", force: true do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["username"], name: "index_people_on_username", unique: true

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

end
