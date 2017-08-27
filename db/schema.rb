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

ActiveRecord::Schema.define(version: 20170827211145) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer "user_id"
    t.string "provider"
    t.string "uid"
    t.string "token"
    t.string "token_secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_authentications_on_deleted_at"
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "authie_sessions", force: :cascade do |t|
    t.string "token"
    t.string "browser_id"
    t.integer "user_id"
    t.boolean "active", default: true
    t.datetime "expires_at"
    t.datetime "login_at"
    t.string "login_ip"
    t.datetime "last_activity_at"
    t.string "last_activity_ip"
    t.string "last_activity_path"
    t.string "user_agent"
    t.integer "requests", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "user_type"
    t.integer "parent_id"
    t.integer "team_id"
    t.datetime "two_factored_at"
    t.string "two_factored_ip"
    t.datetime "password_seen_at"
    t.string "token_hash"
    t.index ["browser_id", "team_id"], name: "index_authie_sessions_on_browser_id_and_team_id"
    t.index ["browser_id"], name: "index_authie_sessions_on_browser_id"
    t.index ["token"], name: "index_authie_sessions_on_token"
    t.index ["token_hash"], name: "index_authie_sessions_on_token_hash"
    t.index ["user_id"], name: "index_authie_sessions_on_user_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.integer "team_id"
    t.integer "invited_by_user_id"
    t.integer "invited_user_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invited_slack_user_uid"
    t.integer "space_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_invitations_on_deleted_at"
    t.index ["team_id"], name: "index_invitations_on_team_id"
  end

  create_table "page_contents", force: :cascade do |t|
    t.integer "page_id"
    t.text "contents"
    t.integer "byte_size", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_page_contents_on_deleted_at"
    t.index ["page_id"], name: "index_page_contents_on_page_id"
  end

  create_table "page_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "page_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "page_desc_idx"
  end

  create_table "pages", force: :cascade do |t|
    t.integer "space_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "word_count", default: 0
    t.integer "parent_id"
    t.integer "sort_order"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_pages_on_deleted_at"
    t.index ["space_id"], name: "index_pages_on_space_id"
  end

  create_table "searchjoy_searches", force: :cascade do |t|
    t.integer "user_id"
    t.string "search_type"
    t.string "query"
    t.string "normalized_query"
    t.integer "results_count"
    t.datetime "created_at"
    t.integer "convertable_id"
    t.string "convertable_type"
    t.datetime "converted_at"
    t.index ["convertable_id", "convertable_type"], name: "index_searchjoy_searches_on_convertable_id_and_convertable_type"
    t.index ["created_at"], name: "index_searchjoy_searches_on_created_at"
    t.index ["search_type", "created_at"], name: "index_searchjoy_searches_on_search_type_and_created_at"
    t.index ["search_type", "normalized_query", "created_at"], name: "index_searchjoy_searches_on_search_type_normalized_query"
  end

  create_table "space_members", force: :cascade do |t|
    t.integer "team_member_id"
    t.integer "space_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_space_members_on_deleted_at"
    t.index ["space_id"], name: "index_space_members_on_space_id"
    t.index ["team_member_id"], name: "index_space_members_on_team_member_id"
  end

  create_table "spaces", force: :cascade do |t|
    t.integer "team_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "cover_data"
    t.string "access_control"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_spaces_on_deleted_at"
    t.index ["team_id"], name: "index_spaces_on_team_id"
  end

  create_table "team_authentications", force: :cascade do |t|
    t.integer "team_id"
    t.string "provider"
    t.string "token"
    t.string "scopes", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "team_uid"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_team_authentications_on_deleted_at"
    t.index ["team_id", "provider"], name: "index_team_authentications_on_team_id_and_provider"
    t.index ["team_id"], name: "index_team_authentications_on_team_id"
  end

  create_table "team_members", force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_team_members_on_deleted_at"
    t.index ["team_id"], name: "index_team_members_on_team_id"
    t.index ["user_id"], name: "index_team_members_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subdomain"
    t.jsonb "logo_data"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_teams_on_deleted_at"
    t.index ["subdomain"], name: "index_teams_on_subdomain"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.boolean "allow_email_login", default: true
    t.jsonb "avatar_data"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "deleted_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "authentications", "users", on_delete: :cascade
  add_foreign_key "invitations", "spaces"
  add_foreign_key "invitations", "teams"
  add_foreign_key "page_contents", "pages", on_delete: :cascade
  add_foreign_key "pages", "spaces", on_delete: :cascade
  add_foreign_key "space_members", "spaces"
  add_foreign_key "space_members", "team_members"
  add_foreign_key "spaces", "teams", on_delete: :cascade
  add_foreign_key "team_authentications", "teams"
  add_foreign_key "team_members", "teams", on_delete: :cascade
  add_foreign_key "team_members", "users", on_delete: :cascade
end
