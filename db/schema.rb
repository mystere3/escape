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

ActiveRecord::Schema.define(version: 20150516144328) do

  create_table "games", force: :cascade do |t|
    t.boolean  "gloves_has"
    t.boolean  "mop_has"
    t.boolean  "knife_has"
    t.boolean  "door_locked"
    t.boolean  "door_open"
    t.boolean  "desk_open"
    t.boolean  "pen_has"
    t.boolean  "paper_has"
    t.text     "paper_content"
    t.boolean  "puzzlebox_open"
    t.boolean  "key_has"
    t.boolean  "glassbox_open"
    t.boolean  "circuitbox_open"
    t.boolean  "lights_on"
    t.boolean  "outlets_on"
    t.boolean  "horror_in_room"
    t.boolean  "horror_staggered"
    t.boolean  "horror_stabbed"
    t.boolean  "floor_wet"
    t.integer  "turns_remain"
    t.boolean  "game_over"
    t.integer  "end_count"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "user_id"
    t.boolean  "puzzlebox_has"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
    t.string   "name"
    t.integer  "last_game_played"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
