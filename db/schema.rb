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

ActiveRecord::Schema.define(version: 2022_10_08_195259) do

  create_table "access_levels", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
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

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clubs", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "full_name"
    t.string "internal_name"
    t.string "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["internal_name"], name: "index_clubs_on_internal_name", unique: true
  end

  create_table "clubs_users", id: false, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "club_id"
    t.integer "user_id"
    t.index ["club_id", "user_id"], name: "index_clubs_users_on_club_id_and_user_id", unique: true
    t.index ["user_id"], name: "fk_rails_b7c6964840"
  end

  create_table "enrolled_clubs_members", id: false, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "club_id", null: false
    t.integer "user_id", null: false
    t.index ["club_id", "user_id"], name: "index_enrolled_clubs_members_on_club_id_and_user_id", unique: true
    t.index ["club_id"], name: "index_enrolled_clubs_members_on_club_id"
    t.index ["user_id"], name: "index_enrolled_clubs_members_on_user_id"
  end

  create_table "events", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "location"
    t.string "website"
    t.text "description", size: :medium
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "registration_open_date"
    t.datetime "registration_close_date"
    t.boolean "show_ticket_count", default: true
    t.string "bank_number"
    t.string "contact_email"
    t.string "export_file_name"
    t.string "export_content_type"
    t.integer "export_file_size"
    t.datetime "export_updated_at"
    t.string "export_status"
    t.boolean "show_statistics"
    t.integer "club_id"
    t.boolean "registration_open", default: true
    t.text "signature"
    t.index ["club_id"], name: "fk_rails_fc45ac705d"
  end

  create_table "partners", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.index ["event_id"], name: "fk_rails_188986c214"
    t.index ["reset_password_token"], name: "index_partners_on_reset_password_token", unique: true
  end

  create_table "registrations", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "barcode"
    t.string "name"
    t.string "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "event_id"
    t.string "student_number"
    t.integer "paid"
    t.integer "price"
    t.datetime "checked_in_at"
    t.text "comment"
    t.string "barcode_data"
    t.string "payment_code"
    t.integer "access_level_id", null: false
    t.index ["access_level_id"], name: "index_registrations_on_access_level_id"
    t.index ["event_id"], name: "index_registrations_on_event_id"
    t.index ["payment_code"], name: "index_registrations_on_payment_code", unique: true
  end

  create_table "users", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "username", null: false
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

  create_table "versions", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "access_levels", "events", on_delete: :cascade
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "clubs_users", "clubs", on_delete: :cascade
  add_foreign_key "clubs_users", "users", on_delete: :cascade
  add_foreign_key "enrolled_clubs_members", "clubs", on_delete: :cascade
  add_foreign_key "enrolled_clubs_members", "users", on_delete: :cascade
  add_foreign_key "events", "clubs", on_delete: :cascade
  add_foreign_key "partners", "access_levels"
  add_foreign_key "partners", "events", on_delete: :cascade
  add_foreign_key "registrations", "access_levels"
  add_foreign_key "registrations", "events", on_delete: :cascade
end
