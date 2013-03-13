# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110920145044) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.integer  "security_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "annual_reports", :force => true do |t|
    t.date     "deadline"
    t.string   "title"
    t.string   "more_info"
    t.integer  "phase"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_configs", :force => true do |t|
    t.boolean  "crc"
    t.boolean  "gas"
    t.boolean  "compare_meters"
    t.text     "elec_default_query"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calculation_check_tasks", :force => true do |t|
    t.integer  "status"
    t.boolean  "in_order"
    t.text     "more_info"
    t.integer  "footprint_report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cca_exemptions", :force => true do |t|
    t.string   "tui"
    t.string   "company_name"
    t.float    "emissions_covered"
    t.integer  "cca_exemptions_task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cca_exemptions_tasks", :force => true do |t|
    t.date     "deadline"
    t.integer  "status"
    t.string   "more_info"
    t.integer  "footprint_report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "confirm_energy_supply_tasks", :force => true do |t|
    t.integer  "status"
    t.boolean  "is_confirmed"
    t.integer  "annual_report_id"
    t.string   "more_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "controller_display_names", :force => true do |t|
    t.string   "controller_name"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversion_factors", :force => true do |t|
    t.integer  "source_type_id"
    t.integer  "year"
    t.float    "rate"
    t.boolean  "official"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "designated_changes", :force => true do |t|
    t.string   "text"
    t.date     "date_of_change"
    t.integer  "designated_changes_task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "designated_changes_tasks", :force => true do |t|
    t.date     "deadline"
    t.integer  "status"
    t.string   "more_info"
    t.integer  "footprint_report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "disclosure_tasks", :force => true do |t|
    t.integer  "annual_report_id"
    t.string   "more_info"
    t.integer  "status"
    t.integer  "question_1"
    t.integer  "question_2"
    t.integer  "question_3"
    t.integer  "question_4"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_types", :force => true do |t|
    t.string   "name"
    t.integer  "source_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_uploads", :force => true do |t|
    t.integer  "user_id"
    t.string   "purchase_order_number"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "document_type_id"
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
  end

  create_table "early_action_metric_tasks", :force => true do |t|
    t.integer  "annual_report_id"
    t.integer  "status"
    t.string   "more_info"
    t.integer  "coverage"
    t.integer  "scheme_provider_id"
    t.integer  "voluntary_amr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "electricity_generating_credits_tasks", :force => true do |t|
    t.integer  "credits"
    t.string   "more_info"
    t.integer  "status"
    t.integer  "annual_report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "electricity_readings", :force => true do |t|
    t.integer  "electricity_upload_id"
    t.decimal  "electricity_value",     :precision => 32, :scale => 16
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "meter_id"
    t.datetime "start_time"
    t.datetime "mid_time"
    t.integer  "user_id"
  end

  create_table "electricity_uploads", :force => true do |t|
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "meter_id"
    t.integer  "interval"
  end

  create_table "emission_metrics_tasks", :force => true do |t|
    t.float    "core_energy_ETS"
    t.float    "non_core_energy_ETS"
    t.float    "cca_subsidiaries"
    t.float    "cca_core_energy"
    t.float    "cca_non_core_energy"
    t.float    "electricity_generated_credit"
    t.float    "renewables_generation"
    t.text     "more_info"
    t.integer  "status"
    t.integer  "footprint_report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "energy_metrics_tasks", :force => true do |t|
    t.integer  "footprint_report_id"
    t.float    "core_electricity"
    t.float    "core_gas"
    t.float    "non_core_electricity"
    t.float    "non_core_gas"
    t.float    "aviation_spirit"
    t.float    "blast_furnace_gas"
    t.float    "burning_fuels"
    t.float    "coke_oven_gas"
    t.float    "colliery_methane"
    t.float    "diesel"
    t.float    "fuel_oil"
    t.float    "gas_oil"
    t.float    "industrial_coal"
    t.float    "LPG"
    t.float    "lubricants"
    t.float    "waste"
    t.float    "naphtha"
    t.float    "natural_gas"
    t.float    "petrol_gas"
    t.float    "petrol"
    t.text     "more_info"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "footprint_reports", :force => true do |t|
    t.date     "deadline"
    t.string   "title"
    t.string   "more_info"
    t.integer  "phase"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fuel_lists", :force => true do |t|
    t.string   "fuel_name"
    t.float    "emission_factor_v1"
    t.integer  "residual_emission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gas_readings", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "gas_value",     :precision => 32, :scale => 16
    t.datetime "mid_time"
    t.integer  "meter_id"
    t.integer  "gas_upload_id"
  end

  create_table "gas_uploads", :force => true do |t|
    t.integer  "user_id"
    t.integer  "meter_id"
    t.string   "filename"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "interval"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "growth_metric_tasks", :force => true do |t|
    t.integer  "annual_report_id"
    t.integer  "status"
    t.string   "more_info"
    t.float    "turnover"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kwh_equivalents", :force => true do |t|
    t.integer  "source_type_id"
    t.string   "name"
    t.float    "conversion_factor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_id"
  end

  create_table "meter_groups", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meters", :force => true do |t|
    t.string   "meter_identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "source_type_id"
  end

  create_table "node_entries", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "node_id"
    t.string   "node_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "other_fuels", :force => true do |t|
    t.integer  "other_fuels_task_id"
    t.string   "description"
    t.float    "amount"
    t.integer  "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "other_fuels_tasks", :force => true do |t|
    t.integer  "status"
    t.integer  "footprint_report_id"
    t.text     "more_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reconfirmation_exemption_tasks", :force => true do |t|
    t.integer  "choice"
    t.integer  "status"
    t.integer  "footprint_report_id"
    t.text     "more_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "records", :force => true do |t|
    t.integer  "activity_id"
    t.integer  "user_id"
    t.datetime "timestamp"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "renewable_tasks", :force => true do |t|
    t.integer  "status"
    t.string   "more_info"
    t.date     "deadline"
    t.integer  "annual_report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "renewables", :force => true do |t|
    t.integer  "renewable_task_id"
    t.float    "roc"
    t.float    "fit"
    t.float    "renewablesGenerated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_other_fuels_tasks", :force => true do |t|
    t.integer  "annual_report_id"
    t.float    "non_core_electricity"
    t.float    "non_core_gas"
    t.float    "aviation_spirit"
    t.float    "blast_furnace_gas"
    t.float    "burning_fuels"
    t.float    "coke_oven_gas"
    t.float    "colliery_methane"
    t.float    "diesel"
    t.float    "fuel_oil"
    t.float    "gas_oil"
    t.float    "industrial_coal"
    t.float    "LPG"
    t.float    "lubricants"
    t.float    "waste"
    t.float    "naphtha"
    t.float    "natural_gas"
    t.float    "petrol_gas"
    t.float    "petrol"
    t.text     "more_info"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "residual_emissions", :force => true do |t|
    t.float    "tonnes_c02"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "residual_emissions_task_id"
  end

  create_table "residual_emissions_tasks", :force => true do |t|
    t.integer  "footprint_report_id"
    t.integer  "status"
    t.text     "more_info"
    t.date     "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scheme_providers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "significant_group_undertakings", :force => true do |t|
    t.integer  "significant_group_undertakings_task_id"
    t.string   "name"
    t.float    "carbon_emitted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "significant_group_undertakings_tasks", :force => true do |t|
    t.integer  "annual_report_id"
    t.integer  "status"
    t.string   "more_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "source_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "support_tickets", :force => true do |t|
    t.string   "subject"
    t.string   "message"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariffs", :force => true do |t|
    t.float    "day_rate"
    t.float    "night_rate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
