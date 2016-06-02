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

ActiveRecord::Schema.define(version: 20160602060813) do

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.string   "data_fingerprint"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"

  create_table "customers", force: :cascade do |t|
    t.string   "account_no"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "mi",               limit: 1
    t.string   "zone"
    t.string   "street"
    t.string   "barangay"
    t.string   "municipality"
    t.string   "province"
    t.integer  "consumer_type_id"
    t.date     "date_connected"
    t.string   "status",                     default: "active"
    t.integer  "created_by"
    t.integer  "last_updated_by"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "customers", ["account_no"], name: "index_customers_on_account_no", unique: true

  create_table "deposit_attachments", force: :cascade do |t|
    t.integer  "registration_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.string   "subtitle"
    t.string   "slug"
    t.text     "body"
    t.text     "short_body"
    t.integer  "page_id"
    t.date     "publish_date"
    t.boolean  "active",             default: true
    t.integer  "display_order"
    t.boolean  "show_in_menu",       default: true
    t.boolean  "is_required",        default: false
    t.boolean  "is_root",            default: false
    t.boolean  "is_contact",         default: false
    t.string   "page_type",          default: "page"
    t.string   "published_by"
    t.boolean  "is_featured",        default: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "meta_description"
    t.string   "meta_title"
    t.integer  "created_by"
    t.integer  "last_updated_by"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "pages", ["slug"], name: "index_pages_on_slug"

  create_table "registrations", force: :cascade do |t|
    t.string   "registration_no"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "occupation"
    t.string   "grp_org_comp"
    t.text     "residential_address"
    t.integer  "age"
    t.string   "gender"
    t.date     "birth_date"
    t.string   "contact_numbers"
    t.string   "emergency_contact_name"
    t.string   "emergency_contact_number"
    t.boolean  "receive_newsletters",                              default: false
    t.boolean  "terms_accepted",                                   default: false
    t.datetime "terms_accepted_at"
    t.integer  "age_on_race_day"
    t.boolean  "paid_online",                                      default: false
    t.boolean  "approved",                                         default: false
    t.datetime "approved_at"
    t.integer  "approved_by"
    t.string   "category"
    t.string   "singlet"
    t.boolean  "confirmation_sent",                                default: false
    t.datetime "confirmation_sent_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.boolean  "is_walk_in",                                       default: false
    t.boolean  "admin_encoded",                                    default: false
    t.boolean  "is_paid_on_site",                                  default: false
    t.boolean  "active",                                           default: true
    t.string   "bank_name"
    t.date     "date_registered"
    t.boolean  "is_free_registraion",                              default: false
    t.decimal  "discount",                 precision: 8, scale: 2, default: 0.0
    t.decimal  "amount",                   precision: 8, scale: 2, default: 0.0
    t.text     "remarks"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "users", force: :cascade do |t|
    t.string   "email",                                           null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "first_name"
    t.string   "mi"
    t.string   "last_name"
    t.string   "suffix"
    t.date     "birthdate"
    t.integer  "age"
    t.string   "gender"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string   "last_login_from_ip_address"
    t.boolean  "active",                          default: true
    t.boolean  "should_receive_email",            default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at"
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token"

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end
