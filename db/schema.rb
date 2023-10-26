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

ActiveRecord::Schema.define(version: 2023_10_24_175459) do

  create_table "base_profiles", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "auth_token"
    t.string "roll"
    t.string "profile_name"
    t.string "profile_url"
    t.string "connect_url"
    t.string "linkedin_tags"
    t.string "connections"
    t.string "profile_pic"
    t.string "bg_pic"
    t.text "metadata"
    t.string "course"
    t.string "batch"
    t.string "phone"
    t.boolean "is_deleted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest", default: "", null: false
    t.string "password"
    t.index ["auth_token"], name: "index_base_profiles_on_auth_token"
    t.index ["batch"], name: "index_base_profiles_on_batch"
    t.index ["is_deleted"], name: "index_base_profiles_on_is_deleted"
    t.index ["phone"], name: "index_base_profiles_on_phone"
    t.index ["profile_name"], name: "index_base_profiles_on_profile_name"
    t.index ["profile_url"], name: "index_base_profiles_on_profile_url"
    t.index ["roll"], name: "index_base_profiles_on_roll"
  end

end
