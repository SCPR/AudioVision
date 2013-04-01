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

ActiveRecord::Schema.define(version: 20130321045050) do

  create_table "attributions", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "role"
    t.integer  "reporter_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attributions", ["post_id", "role"], name: "index_attributions_on_post_id_and_role"
  add_index "attributions", ["reporter_id"], name: "index_attributions_on_reporter_id"

  create_table "flatpages", force: true do |t|
    t.string   "path"
    t.string   "title"
    t.string   "description"
    t.text     "content"
    t.string   "redirect_to"
    t.text     "extra_head"
    t.text     "extra_footer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flatpages", ["path"], name: "index_flatpages_on_path"

  create_table "permissions", force: true do |t|
    t.string   "resource"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["resource"], name: "index_permissions_on_resource"

  create_table "post_assets", force: true do |t|
    t.integer  "asset_id"
    t.integer  "post_id"
    t.integer  "position"
    t.text     "caption"
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

  create_table "reporters", force: true do |t|
    t.string   "name"
    t.text     "bio"
    t.integer  "user_id"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reporters", ["slug"], name: "index_reporters_on_slug"
  add_index "reporters", ["user_id"], name: "index_reporters_on_user_id"

end
