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

ActiveRecord::Schema.define(version: 20140210161533) do

  create_table "characters", force: true do |t|
    t.string   "nickname"
    t.integer  "scene_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "characters", ["scene_id"], name: "index_characters_on_scene_id"

  create_table "friends", force: true do |t|
    t.integer  "user_id"
    t.string   "friend"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friends", ["user_id"], name: "index_friends_on_user_id"

  create_table "identities", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lines", force: true do |t|
    t.text     "content"
    t.string   "kind"
    t.integer  "character_id"
    t.integer  "scene_id"
    t.string   "nickname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lines", ["character_id"], name: "index_lines_on_character_id"

  create_table "messages", force: true do |t|
    t.integer  "user_id"
    t.string   "from"
    t.string   "title"
    t.text     "content"
    t.boolean  "read"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id"

  create_table "queueconnects", force: true do |t|
    t.integer  "userid"
    t.text     "name"
    t.integer  "userrating"
    t.integer  "desiredrating"
    t.boolean  "guest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scenes", force: true do |t|
    t.string   "users"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",      limit: 10,  default: "waiting"
    t.string   "uuid",       limit: 50
    t.string   "name",       limit: 100
    t.string   "title"
    t.text     "starter"
    t.integer  "likes"
    t.integer  "livecount"
  end

  create_table "starters", force: true do |t|
    t.text     "content"
    t.string   "title"
    t.integer  "scene_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "starters", ["scene_id"], name: "index_starters_on_scene_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "location"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "favmovie"
    t.string   "favactor"
    t.string   "about"
    t.string   "image"
    t.text     "rating"
    t.integer  "scenecount"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["name"], name: "index_users_on_name", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
