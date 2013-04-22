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

ActiveRecord::Schema.define(version: 20130422185311) do

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

  create_table "billboards", force: true do |t|
    t.integer  "layout"
    t.integer  "status"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "billboards", ["status"], name: "index_billboards_on_status"

  create_table "buckets", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "buckets", ["key"], name: "index_buckets_on_key"

  create_table "categories", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["slug"], name: "index_categories_on_slug"

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

  create_table "post_references", force: true do |t|
    t.string   "referrer_type"
    t.integer  "referrer_id"
    t.integer  "post_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_references", ["position"], name: "index_post_references_on_position"
  add_index "post_references", ["post_id"], name: "index_post_references_on_post_id"
  add_index "post_references", ["referrer_type", "referrer_id"], name: "index_post_references_on_referrer_type_and_referrer_id"

  create_table "posts", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "status"
    t.text     "body"
    t.datetime "published_at"
    t.text     "teaser"
    t.integer  "media_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.string   "related_kpcc_article_url"
    t.string   "subtitle"
    t.boolean  "related_kpcc_article_json_is_cached", default: false
  end

  add_index "posts", ["category_id"], name: "index_posts_on_category_id"
  add_index "posts", ["media_type"], name: "index_posts_on_media_type"
  add_index "posts", ["status", "published_at"], name: "index_posts_on_status_and_published_at"

  create_table "publish_alarms", force: true do |t|
    t.integer  "content_id"
    t.string   "content_type"
    t.datetime "fire_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "publish_alarms", ["content_id", "content_type"], name: "index_publish_alarms_on_content_id_and_content_type"
  add_index "publish_alarms", ["fire_at"], name: "index_publish_alarms_on_fire_at"

  create_table "reporters", force: true do |t|
    t.string   "name"
    t.text     "bio"
    t.integer  "user_id"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_listed"
    t.integer  "asset_id"
    t.string   "twitter_handle"
    t.string   "email"
  end

  add_index "reporters", ["is_listed"], name: "index_reporters_on_is_listed"
  add_index "reporters", ["slug"], name: "index_reporters_on_slug"
  add_index "reporters", ["user_id"], name: "index_reporters_on_user_id"

  create_table "user_permissions", force: true do |t|
    t.integer  "user_id"
    t.integer  "permission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_permissions", ["permission_id"], name: "index_user_permissions_on_permission_id"
  add_index "user_permissions", ["user_id", "permission_id"], name: "index_user_permissions_on_user_id_and_permission_id"
  add_index "user_permissions", ["user_id"], name: "index_user_permissions_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "can_login"
    t.boolean  "is_superuser"
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
