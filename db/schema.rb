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

ActiveRecord::Schema.define(version: 20130318185032) do

  create_table "authors", force: true do |t|
    t.text    "bio"
    t.integer "user_id"
    t.string  "name"
    t.string  "slug"
  end

  add_index "authors", ["slug"], name: "index_authors_on_slug"
  add_index "authors", ["user_id"], name: "index_authors_on_user_id"

  create_table "flatpages", force: true do |t|
    t.string   "path"
    t.string   "title"
    t.string   "description"
    t.string   "content"
    t.string   "redirect_to"
    t.string   "extra_head"
    t.string   "extra_footer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flatpages", ["path"], name: "index_flatpages_on_path"

  create_table "post_assets", force: true do |t|
    t.integer  "asset_id"
    t.integer  "post_id"
    t.integer  "position"
    t.string   "caption"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_assets", ["post_id", "position"], name: "index_post_assets_on_post_id_and_position"

  create_table "posts", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "status"
    t.text     "body"
    t.datetime "published_at"
    t.text     "teaser"
    t.string   "media_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["media_type"], name: "index_posts_on_media_type"
  add_index "posts", ["status", "published_at"], name: "index_posts_on_status_and_published_at"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "is_superuser"
    t.boolean  "can_login",       default: true
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email", "can_login"], name: "index_users_on_email_and_can_login"

end
