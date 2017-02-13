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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120305024339) do

  create_table "account_transactions", :force => true do |t|
    t.integer  "account_id",                                                               :null => false
    t.integer  "operator_id"
    t.integer  "operation",                                                 :default => 0, :null => false
    t.integer  "op_way",                                                    :default => 0, :null => false
    t.decimal  "amount",                     :precision => 12, :scale => 2
    t.string   "note",        :limit => 300
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts", :force => true do |t|
    t.integer  "party_id",                                                   :null => false
    t.decimal  "balance",    :precision => 14, :scale => 4, :default => 0.0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ad_containers", :force => true do |t|
    t.integer  "party_id",                                                                       :null => false
    t.integer  "channel_id"
    t.integer  "os_type"
    t.integer  "status"
    t.integer  "request_count",                                                 :default => 0
    t.integer  "show_count",                                                    :default => 0
    t.integer  "click_count",                                                   :default => 0
    t.decimal  "latitude",                      :precision => 15, :scale => 12
    t.decimal  "longitude",                     :precision => 15, :scale => 12
    t.decimal  "income",                        :precision => 14, :scale => 4,  :default => 0.0, :null => false
    t.string   "name",          :limit => 120,                                                   :null => false
    t.string   "url",           :limit => 512
    t.string   "identity",      :limit => 100,                                                   :null => false
    t.string   "description",   :limit => 2100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  create_table "ad_containers_content_categories", :id => false, :force => true do |t|
    t.integer "ad_container_id"
    t.integer "content_category_id"
  end

  create_table "ad_containers_publish_policies", :id => false, :force => true do |t|
    t.integer "ad_container_id",   :null => false
    t.integer "publish_policy_id", :null => false
  end

  add_index "ad_containers_publish_policies", ["ad_container_id", "publish_policy_id"], :name => "uidx_ad_containers_publish_policies", :unique => true

  create_table "ad_daily_summaries", :force => true do |t|
    t.integer  "party_id"
    t.integer  "campaign_id"
    t.integer  "publish_policy_id"
    t.integer  "advertisement_id"
    t.integer  "impression_count",                                 :default => 0,   :null => false
    t.integer  "click_count",                                      :default => 0,   :null => false
    t.decimal  "used_budget",       :precision => 14, :scale => 4, :default => 0.0, :null => false
    t.date     "summary_date",                                                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ad_groups", :force => true do |t|
    t.integer  "campaign_id",                                                  :null => false
    t.string   "name",           :limit => 120,                                :null => false
    t.string   "call_to_action", :limit => 10,                                 :null => false
    t.date     "start_from",                                                   :null => false
    t.date     "end_to"
    t.integer  "pay_method_id",                                                :null => false
    t.decimal  "bid_price",                     :precision => 10, :scale => 2
    t.decimal  "daily_budget",                  :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ad_requests", :force => true do |t|
    t.integer  "publisher_id",                                                                         :null => false
    t.integer  "ad_container_id",                                                                      :null => false
    t.integer  "agent_id"
    t.integer  "advertisement_id"
    t.integer  "publish_policy_id"
    t.integer  "campaign_id"
    t.integer  "ad_owner_id"
    t.decimal  "unit_price",                         :precision => 10, :scale => 4
    t.integer  "pay_method_id"
    t.boolean  "fulfilled",                                                         :default => false, :null => false
    t.boolean  "shown",                                                             :default => false, :null => false
    t.boolean  "clicked",                                                           :default => false, :null => false
    t.boolean  "paid",                                                              :default => false, :null => false
    t.float    "publisher_share_rate"
    t.float    "agent_share_rate"
    t.date     "request_date"
    t.string   "ip_address",           :limit => 15
    t.string   "size_code",            :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ad_requests", ["ad_owner_id"], :name => "index_ad_requests_on_ad_owner_id"
  add_index "ad_requests", ["ip_address", "ad_container_id", "size_code"], :name => "idx_ad_requests_ip_container_size"
  add_index "ad_requests", ["publisher_id"], :name => "index_ad_requests_on_publisher_id"
  add_index "ad_requests", ["request_date"], :name => "index_ad_requests_on_request_date"

  create_table "ad_resources", :force => true do |t|
    t.integer  "member_id",                        :null => false
    t.integer  "advertisement_id"
    t.integer  "width"
    t.integer  "height"
    t.string   "size_code",         :limit => 30
    t.string   "ad_format",         :limit => 30
    t.string   "name",              :limit => 30
    t.string   "text",              :limit => 600
    t.string   "file"
    t.string   "file_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ad_show_controls", :force => true do |t|
    t.integer  "party_id",                                                          :null => false
    t.integer  "advertisement_id",                                                  :null => false
    t.integer  "publish_policy_id",                                                 :null => false
    t.integer  "campaign_id",                                                       :null => false
    t.integer  "channel_id",                                                        :null => false
    t.float    "weight"
    t.decimal  "unit_price",                         :precision => 10, :scale => 4, :null => false
    t.date     "begin",                                                             :null => false
    t.date     "end"
    t.string   "ad_format",          :limit => 30,                                  :null => false
    t.string   "size_codes",         :limit => 300
    t.string   "content_categories", :limit => 1024
    t.string   "ad_containers",      :limit => 4096
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ad_show_controls", ["advertisement_id"], :name => "index_ad_show_controls_on_advertisement_id"

  create_table "advertisements", :force => true do |t|
    t.integer  "party_id",                                          :null => false
    t.integer  "status",                          :default => 0,    :null => false
    t.integer  "impression_count",                :default => 0
    t.integer  "click_count",                     :default => 0
    t.integer  "used_budget",                     :default => 0
    t.integer  "decimal",                         :default => 0
    t.boolean  "owner_maintained",                :default => true, :null => false
    t.string   "ad_format",        :limit => 20,                    :null => false
    t.string   "name",             :limit => 120,                   :null => false
    t.string   "content_url",                                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "approve_logs", :force => true do |t|
    t.integer  "member_id",                                  :null => false
    t.integer  "target_id",                                  :null => false
    t.integer  "result",                      :default => 0, :null => false
    t.string   "target_type", :limit => 1000,                :null => false
    t.string   "opinion",     :limit => 300
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bank_accounts", :force => true do |t|
    t.integer  "party_id",                    :null => false
    t.string   "bank_name",    :limit => 300, :null => false
    t.string   "account_name", :limit => 90,  :null => false
    t.string   "bank_serial",  :limit => 30,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "black_lists", :force => true do |t|
    t.integer  "party_id",          :null => false
    t.integer  "black_member_id",   :null => false
    t.string   "black_member_type", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns", :force => true do |t|
    t.integer  "party_id",                                                                    :null => false
    t.date     "start_from",                                                                  :null => false
    t.date     "end_to"
    t.decimal  "budget",                      :precision => 12, :scale => 2, :default => 0.0, :null => false
    t.decimal  "used_budget",                 :precision => 15, :scale => 5, :default => 0.0, :null => false
    t.decimal  "daily_budget",                :precision => 12, :scale => 2
    t.string   "name",         :limit => 300,                                                 :null => false
    t.string   "description",  :limit => 750
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash_claims", :force => true do |t|
    t.integer  "account_id",                                                                  :null => false
    t.integer  "operator_id"
    t.decimal  "amount",                      :precision => 12, :scale => 2, :default => 0.0, :null => false
    t.integer  "result",                                                     :default => 0,   :null => false
    t.string   "bank_name",    :limit => 300,                                                 :null => false
    t.string   "account_no",   :limit => 30,                                                  :null => false
    t.string   "account_name", :limit => 90,                                                  :null => false
    t.string   "fail_reason",  :limit => 300
    t.string   "bill_no",      :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channels", :force => true do |t|
    t.string   "name",              :limit => 30, :null => false
    t.string   "ad_container_name", :limit => 60, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_categories", :force => true do |t|
    t.boolean  "for_ad_container",                :default => true, :null => false
    t.boolean  "for_advertisement",               :default => true, :null => false
    t.string   "name",              :limit => 30,                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_categories_publish_policies", :id => false, :force => true do |t|
    t.integer "publish_policy_id"
    t.integer "content_category_id"
  end

  create_table "contracts", :force => true do |t|
    t.integer  "business_type",                      :default => 0,     :null => false
    t.integer  "party_id",                                              :null => false
    t.boolean  "expiration_processed",               :default => false, :null => false
    t.date     "start_from",                                            :null => false
    t.date     "expired_at",                                            :null => false
    t.string   "contact_person",       :limit => 60,                    :null => false
    t.string   "mobile_phone",         :limit => 20,                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "share_rate_1"
    t.float    "share_rate_2"
  end

  create_table "members", :force => true do |t|
    t.boolean  "is_admin",                      :default => false, :null => false
    t.integer  "status",                        :default => 0,     :null => false
    t.integer  "party_id"
    t.string   "email",                                            :null => false
    t.string   "password_hash",                                    :null => false
    t.string   "ha1",                                              :null => false
    t.string   "real_name",       :limit => 30,                    :null => false
    t.string   "activation_code", :limit => 32
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members_roles", :id => false, :force => true do |t|
    t.integer "member_id", :null => false
    t.integer "role_id",   :null => false
  end

  add_index "members_roles", ["member_id", "role_id"], :name => "index_members_roles_on_member_id_and_role_id", :unique => true

  create_table "parties", :force => true do |t|
    t.integer  "agent_id"
    t.integer  "party_type"
    t.boolean  "adhub_operator",                  :default => false, :null => false
    t.string   "name",             :limit => 300,                    :null => false
    t.string   "address",          :limit => 300
    t.string   "phone_number",     :limit => 50
    t.string   "post_code",        :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sales_id"
    t.integer  "ad_maintained_by",                :default => 0
    t.boolean  "archived",                        :default => false
  end

  create_table "pay_methods", :force => true do |t|
    t.integer  "unit",                        :default => 0, :null => false
    t.integer  "pay_on",                      :default => 0
    t.string   "name",          :limit => 10,                :null => false
    t.string   "note",          :limit => 60,                :null => false
    t.string   "effect_string", :limit => 90
    t.string   "string",        :limit => 90
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prices", :force => true do |t|
    t.integer  "pay_method_id",                                                 :null => false
    t.integer  "channel_id"
    t.integer  "party_id",                                                      :null => false
    t.decimal  "base_price",    :precision => 12, :scale => 4, :default => 0.0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publish_policies", :force => true do |t|
    t.integer  "campaign_id",                                                                            :null => false
    t.integer  "advertisement_id",                                                                       :null => false
    t.integer  "channel_id",                                                                             :null => false
    t.integer  "status",                                                              :default => 0,     :null => false
    t.date     "start_from",                                                                             :null => false
    t.date     "end_to"
    t.integer  "pay_method_id",                                                                          :null => false
    t.decimal  "bid_price",                            :precision => 12, :scale => 4
    t.decimal  "daily_budget",                         :precision => 10, :scale => 2
    t.decimal  "used_budget",                          :precision => 14, :scale => 4, :default => 0.0
    t.string   "name",                  :limit => 120,                                                   :null => false
    t.string   "call_to_action",        :limit => 30,                                 :default => "url", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "call_to_action_params"
    t.integer  "step",                                                                :default => 1
  end

  create_table "publisher_daily_summaries", :force => true do |t|
    t.integer  "party_id",                                       :default => 0,   :null => false
    t.integer  "ad_container_id",                                :default => 0,   :null => false
    t.integer  "request_count",                                  :default => 0,   :null => false
    t.integer  "shown_count",                                    :default => 0,   :null => false
    t.integer  "click_count",                                    :default => 0,   :null => false
    t.integer  "fulfill_count",                                  :default => 0,   :null => false
    t.integer  "integer",                                        :default => 0,   :null => false
    t.date     "summary_date",                                                    :null => false
    t.decimal  "income",          :precision => 14, :scale => 4, :default => 0.0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string  "code",                   :limit => 15,  :null => false
    t.string  "name",                   :limit => 60,  :null => false
    t.integer "required_contract_type"
    t.string  "note",                   :limit => 300
  end

  create_table "sdks", :force => true do |t|
    t.integer  "os_type",    :null => false
    t.integer  "status",     :null => false
    t.string   "name"
    t.string   "version"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "system_parameters", :force => true do |t|
    t.string   "name",          :limit => 30,                  :null => false
    t.integer  "value_type",                    :default => 0, :null => false
    t.integer  "int_value"
    t.float    "float_value"
    t.date     "date_value"
    t.string   "string_value",  :limit => 1000
    t.datetime "time_value"
    t.boolean  "boolean_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
