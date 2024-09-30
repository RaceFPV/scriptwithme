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

ActiveRecord::Schema[7.2].define(version: 2024_09_30_050306) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", force: :cascade do |t|
    t.string "nickname"
    t.bigint "scene_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["scene_id"], name: "index_characters_on_scene_id"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "friends", force: :cascade do |t|
    t.string "user_id"
    t.string "friend"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "identities", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "lines", force: :cascade do |t|
    t.text "content"
    t.string "kind"
    t.bigint "character_id"
    t.bigint "scene_id"
    t.string "nickname"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["character_id"], name: "index_lines_on_character_id"
    t.index ["scene_id"], name: "index_lines_on_scene_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "user_id"
    t.string "from"
    t.string "title"
    t.text "content"
    t.boolean "read"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "queueconnects", force: :cascade do |t|
    t.integer "userid"
    t.text "name"
    t.integer "userrating"
    t.integer "desiredrating"
    t.boolean "guest"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "scenes", force: :cascade do |t|
    t.string "users"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "state", limit: 10, default: "waiting"
    t.string "uuid", limit: 50
    t.string "name", limit: 100
    t.string "title"
    t.text "starter"
    t.integer "likes"
    t.integer "livecount"
    t.string "aasm_state"
  end

  create_table "starters", force: :cascade do |t|
    t.text "content"
    t.string "title"
    t.bigint "scene_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["scene_id"], name: "index_starters_on_scene_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "remember_token"
    t.boolean "admin"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "provider"
    t.string "uid"
    t.string "oauth_token"
    t.datetime "oauth_expires_at", precision: nil
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
