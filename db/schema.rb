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

ActiveRecord::Schema[8.1].define(version: 2026_05_14_134300) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "artwork_translations", force: :cascade do |t|
    t.string "alt_text", null: false
    t.bigint "artwork_id", null: false
    t.text "caption"
    t.datetime "created_at", null: false
    t.string "locale", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["artwork_id", "locale"], name: "idx_artwork_translations_on_artwork_and_locale", unique: true
    t.index ["artwork_id"], name: "index_artwork_translations_on_artwork_id"
  end

  create_table "artworks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "dominant_color"
    t.boolean "is_cover", default: false, null: false
    t.bigint "portfolio_category_id", null: false
    t.bigint "project_id"
    t.string "slug", null: false
    t.integer "sort_order", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "visibility", default: "public", null: false
    t.index ["portfolio_category_id"], name: "index_artworks_on_portfolio_category_id"
    t.index ["project_id"], name: "index_artworks_on_project_id"
    t.index ["slug"], name: "index_artworks_on_slug", unique: true
    t.index ["visibility", "sort_order"], name: "index_artworks_on_visibility_and_sort_order"
  end

  create_table "contact_messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "locale", null: false
    t.text "message", null: false
    t.string "name", null: false
    t.string "source", default: "site", null: false
    t.string "status", default: "new", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_contact_messages_on_created_at"
    t.index ["status"], name: "index_contact_messages_on_status"
  end

  create_table "portfolio_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "slug", null: false
    t.integer "sort_order", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_portfolio_categories_on_slug", unique: true
  end

  create_table "portfolio_category_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "locale", null: false
    t.string "name", null: false
    t.bigint "portfolio_category_id", null: false
    t.datetime "updated_at", null: false
    t.index ["portfolio_category_id", "locale"], name: "idx_category_translations_on_category_and_locale", unique: true
    t.index ["portfolio_category_id"], name: "index_portfolio_category_translations_on_portfolio_category_id"
  end

  create_table "project_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "locale", null: false
    t.bigint "project_id", null: false
    t.text "summary"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "locale"], name: "idx_project_translations_on_project_and_locale", unique: true
    t.index ["project_id"], name: "index_project_translations_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "cover_artwork_id"
    t.datetime "created_at", null: false
    t.boolean "is_featured", default: false, null: false
    t.bigint "portfolio_category_id", null: false
    t.string "slug", null: false
    t.integer "sort_order", default: 0, null: false
    t.string "status", default: "finished", null: false
    t.datetime "updated_at", null: false
    t.string "visibility", default: "public", null: false
    t.integer "year"
    t.index ["cover_artwork_id"], name: "index_projects_on_cover_artwork_id"
    t.index ["portfolio_category_id"], name: "index_projects_on_portfolio_category_id"
    t.index ["slug"], name: "index_projects_on_slug", unique: true
    t.index ["visibility", "sort_order"], name: "index_projects_on_visibility_and_sort_order"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "artwork_translations", "artworks"
  add_foreign_key "artworks", "portfolio_categories"
  add_foreign_key "artworks", "projects"
  add_foreign_key "portfolio_category_translations", "portfolio_categories"
  add_foreign_key "project_translations", "projects"
  add_foreign_key "projects", "artworks", column: "cover_artwork_id"
  add_foreign_key "projects", "portfolio_categories"
end
