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

ActiveRecord::Schema.define(version: 20190731154706) do

  create_table "availabilities", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "location"
    t.string   "location_address"
    t.string   "activity"
    t.integer  "group_id"
    t.index ["group_id"], name: "index_availabilities_on_group_id"
    t.index ["user_id"], name: "index_availabilities_on_user_id"
  end

  create_table "children", force: :cascade do |t|
    t.string  "first_name"
    t.date    "birthday"
    t.text    "notes"
    t.integer "user_id"
    t.integer "gender_id"
    t.index ["gender_id"], name: "index_children_on_gender_id"
    t.index ["user_id"], name: "index_children_on_user_id"
  end

  create_table "genders", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_invites", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "email"
    t.datetime "last_emailed"
    t.string   "notes"
    t.index ["group_id"], name: "index_group_invites_on_group_id"
    t.index ["user_id"], name: "index_group_invites_on_user_id"
  end

  create_table "group_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.boolean "admin"
    t.integer "invited_by"
    t.index ["group_id"], name: "index_group_users_on_group_id"
    t.index ["user_id"], name: "index_group_users_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string  "name"
    t.integer "creator_id"
    t.text    "notes"
  end

  create_table "splits", force: :cascade do |t|
    t.integer  "availability_id"
    t.integer  "user_id"
    t.boolean  "approved",        default: false
    t.boolean  "cancelled",       default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["availability_id"], name: "index_splits_on_availability_id"
    t.index ["user_id"], name: "index_splits_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone",                  limit: 11
    t.text     "notes"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size",        limit: 8
    t.datetime "photo_updated_at"
    t.boolean  "admin",                             default: false
    t.integer  "credits",                           default: 10
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
