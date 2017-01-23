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

ActiveRecord::Schema.define(version: 20170123112959) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "token_secret"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["user_id"], name: "index_authentications_on_user_id", using: :btree
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "invitee_user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "token"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "slack_user_id"
    t.index ["team_id"], name: "index_invitations_on_team_id", using: :btree
  end

  create_table "page_contents", force: :cascade do |t|
    t.integer  "page_id"
    t.text     "contents"
    t.integer  "byte_size",  default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["page_id"], name: "index_page_contents_on_page_id", using: :btree
  end

  create_table "pages", force: :cascade do |t|
    t.integer  "space_id"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["space_id"], name: "index_pages_on_space_id", using: :btree
  end

  create_table "spaces", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_spaces_on_team_id", using: :btree
  end

  create_table "team_authentications", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "provider"
    t.string   "token"
    t.string   "scopes",     default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "team_uid"
    t.index ["team_id", "provider"], name: "index_team_authentications_on_team_id_and_provider", using: :btree
    t.index ["team_id"], name: "index_team_authentications_on_team_id", using: :btree
  end

  create_table "team_members", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.string   "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_members_on_team_id", using: :btree
    t.index ["user_id"], name: "index_team_members_on_user_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "subdomain"
    t.jsonb    "logo_data"
    t.index ["subdomain"], name: "index_teams_on_subdomain", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "allow_email_login",      default: true
    t.jsonb    "avatar_data"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "authentications", "users", on_delete: :cascade
  add_foreign_key "invitations", "teams"
  add_foreign_key "page_contents", "pages", on_delete: :cascade
  add_foreign_key "pages", "spaces", on_delete: :cascade
  add_foreign_key "spaces", "teams", on_delete: :cascade
  add_foreign_key "team_authentications", "teams"
  add_foreign_key "team_members", "teams", on_delete: :cascade
  add_foreign_key "team_members", "users", on_delete: :cascade
end
