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

ActiveRecord::Schema.define(version: 20150730221334) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "activity_type_id"
    t.string   "name",             null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "activities", ["activity_type_id"], name: "index_activities_on_activity_type_id", using: :btree

  create_table "activity_types", force: :cascade do |t|
    t.integer "event_id", null: false
    t.string  "name",     null: false
  end

  add_index "activity_types", ["event_id"], name: "index_activity_types_on_event_id", using: :btree

  create_table "administrators", force: :cascade do |t|
    t.integer "user_id",  null: false
    t.integer "event_id", null: false
  end

  add_index "administrators", ["event_id", "user_id"], name: "index_administrators_on_event_id_and_user_id", using: :btree
  add_index "administrators", ["user_id"], name: "index_administrators_on_user_id", using: :btree

  create_table "allocations", force: :cascade do |t|
    t.integer "package_id",       null: false
    t.integer "activity_type_id", null: false
    t.integer "maximum"
  end

  add_index "allocations", ["package_id", "activity_type_id"], name: "index_allocations_on_package_id_and_activity_type_id", unique: true, using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name",                              null: false
    t.string   "slug",                              null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "time_zone",  default: "Wellington", null: false
    t.datetime "start_time",                        null: false
    t.datetime "end_time",                          null: false
  end

  add_index "events", ["slug"], name: "index_events_on_slug", unique: true, using: :btree
  add_index "events", ["start_time", "end_time"], name: "index_events_on_start_time_and_end_time", using: :btree

  create_table "facilitators", force: :cascade do |t|
    t.integer "activity_id", null: false
    t.integer "user_id"
    t.string  "name"
    t.string  "email"
  end

  create_table "individual_activity_prices", force: :cascade do |t|
    t.integer "allocation_id", null: false
    t.integer "price_id",      null: false
  end

  add_index "individual_activity_prices", ["allocation_id"], name: "index_individual_activity_prices_on_allocation_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string  "name"
    t.string  "address"
    t.decimal "latitude",  precision: 9, scale: 6
    t.decimal "longitude", precision: 9, scale: 6
  end

  add_index "locations", ["address"], name: "index_locations_on_address", using: :btree
  add_index "locations", ["latitude", "longitude"], name: "index_locations_on_latitude_and_longitude", using: :btree
  add_index "locations", ["name"], name: "index_locations_on_name", using: :btree

  create_table "package_prices", force: :cascade do |t|
    t.integer  "package_id", null: false
    t.integer  "price_id",   null: false
    t.datetime "start_time", null: false
    t.datetime "end_time",   null: false
  end

  add_index "package_prices", ["package_id", "start_time", "end_time"], name: "index_package_prices_on_package_id_and_start_time_and_end_time", using: :btree

  create_table "packages", force: :cascade do |t|
    t.string  "name"
    t.integer "event_id"
  end

  add_index "packages", ["event_id"], name: "index_packages_on_event_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "registration_id",                                      null: false
    t.decimal  "amount",          precision: 10, scale: 2,             null: false
    t.integer  "state",                                    default: 0, null: false
    t.string   "reference"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  create_table "prices", force: :cascade do |t|
    t.decimal "price", precision: 10, scale: 2, null: false
  end

  create_table "registrations", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "event_id",   null: false
    t.integer  "package_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "registrations", ["package_id", "event_id"], name: "index_registrations_on_package_id_and_event_id", using: :btree
  add_index "registrations", ["user_id", "event_id"], name: "index_registrations_on_user_id_and_event_id", using: :btree

  create_table "scheduled_activities", force: :cascade do |t|
    t.integer "activity_id",  null: false
    t.integer "time_slot_id", null: false
    t.integer "location_id"
  end

  add_index "scheduled_activities", ["activity_id"], name: "index_scheduled_activities_on_activity_id", using: :btree
  add_index "scheduled_activities", ["location_id"], name: "index_scheduled_activities_on_location_id", using: :btree
  add_index "scheduled_activities", ["time_slot_id"], name: "index_scheduled_activities_on_time_slot_id", using: :btree

  create_table "selections", force: :cascade do |t|
    t.integer  "registration_id",       null: false
    t.integer  "scheduled_activity_id", null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "selections", ["registration_id", "scheduled_activity_id"], name: "index_selections_on_registration_id_and_scheduled_activity_id", unique: true, using: :btree
  add_index "selections", ["scheduled_activity_id"], name: "index_selections_on_scheduled_activity_id", using: :btree

  create_table "time_slots", force: :cascade do |t|
    t.integer  "event_id"
    t.datetime "start_time", null: false
    t.datetime "end_time",   null: false
  end

  add_index "time_slots", ["event_id", "start_time", "end_time"], name: "index_time_slots_on_event_id_and_start_time_and_end_time", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                                null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "activities", "activity_types", on_delete: :cascade
  add_foreign_key "activity_types", "events", on_delete: :cascade
  add_foreign_key "administrators", "events", on_delete: :cascade
  add_foreign_key "administrators", "users", on_delete: :cascade
  add_foreign_key "allocations", "activity_types", on_delete: :cascade
  add_foreign_key "allocations", "packages", on_delete: :cascade
  add_foreign_key "facilitators", "activities", on_delete: :cascade
  add_foreign_key "facilitators", "users", on_delete: :nullify
  add_foreign_key "individual_activity_prices", "allocations", on_delete: :cascade
  add_foreign_key "individual_activity_prices", "prices", on_delete: :cascade
  add_foreign_key "package_prices", "packages", on_delete: :cascade
  add_foreign_key "package_prices", "prices", on_delete: :cascade
  add_foreign_key "packages", "events", on_delete: :cascade
  add_foreign_key "payments", "registrations", on_delete: :cascade
  add_foreign_key "registrations", "events", on_delete: :cascade
  add_foreign_key "registrations", "packages", on_delete: :cascade
  add_foreign_key "registrations", "users", on_delete: :cascade
  add_foreign_key "scheduled_activities", "activities", on_delete: :cascade
  add_foreign_key "scheduled_activities", "locations", on_delete: :nullify
  add_foreign_key "scheduled_activities", "time_slots", on_delete: :cascade
  add_foreign_key "selections", "registrations", on_delete: :cascade
  add_foreign_key "selections", "scheduled_activities", on_delete: :cascade
  add_foreign_key "time_slots", "events", on_delete: :cascade
end
