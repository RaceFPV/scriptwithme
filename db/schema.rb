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

ActiveRecord::Schema.define(version: 20140210161533) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", force: :cascade do |t|
    t.string "nickname"
    t.bigint "scene_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["scene_id"], name: "index_characters_on_scene_id"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "friends", force: :cascade do |t|
    t.string "user_id"
    t.string "friend"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identities", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lines", force: :cascade do |t|
    t.text "content"
    t.string "kind"
    t.bigint "character_id"
    t.bigint "scene_id"
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_lines_on_character_id"
    t.index ["scene_id"], name: "index_lines_on_scene_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "user_id"
    t.string "from"
    t.string "title"
    t.text "content"
    t.boolean "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "queueconnects", force: :cascade do |t|
    t.integer "userid"
    t.text "name"
    t.integer "userrating"
    t.integer "desiredrating"
    t.boolean "guest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scenes", force: :cascade do |t|
    t.string "users"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state", limit: 10, default: "waiting"
    t.string "uuid", limit: 50
    t.string "name", limit: 100
    t.string "title"
    t.text "starter"
    t.integer "likes"
    t.integer "livecount"
  end

  create_table "starters", force: :cascade do |t|
    t.text "content"
    t.string "title"
    t.bigint "scene_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scene_id"], name: "index_starters_on_scene_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "remember_token"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.string "location"
    t.string "facebook"
    t.string "twitter"
    t.string "favmovie"
    t.string "favactor"
    t.string "about"
    t.string "image"
    t.text "rating"
    t.integer "scenecount"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

end
