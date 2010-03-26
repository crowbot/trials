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

ActiveRecord::Schema.define(:version => 20100325201654) do

  create_table "agencies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clinical_trials", :force => true do |t|
    t.string   "url"
    t.string   "nct_id"
    t.string   "org_study_id"
    t.string   "secondary_ids"
    t.string   "brief_title"
    t.string   "official_title"
    t.string   "source"
    t.boolean  "has_data_monitoring_committee"
    t.text     "summary"
    t.string   "overall_status"
    t.string   "start_date"
    t.string   "end_date"
    t.string   "completion_date"
    t.string   "completion_date_type"
    t.string   "primary_completion_date"
    t.string   "primary_completion_date_type"
    t.string   "phase"
    t.string   "study_type"
    t.string   "study_design"
    t.integer  "enrollment",                    :limit => 11
    t.string   "enrollment_type"
    t.integer  "condition_id",                  :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "why_stopped"
    t.integer  "number_of_arms",                :limit => 11
    t.integer  "number_of_groups",              :limit => 11
  end

  create_table "contacts", :force => true do |t|
    t.string   "contact_type"
    t.string   "last_name"
    t.string   "phone"
    t.string   "phone_ext"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facilities", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "investigators", :force => true do |t|
    t.string   "last_name"
    t.string   "role"
    t.integer  "location_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.integer  "facility_id",       :limit => 11
    t.integer  "trial_id",          :limit => 11
    t.string   "status"
    t.integer  "contact_id",        :limit => 11
    t.integer  "backup_contact_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "outcomes", :force => true do |t|
    t.string   "outcome_type"
    t.string   "measure"
    t.string   "time_frame"
    t.string   "safety_issue"
    t.string   "description"
    t.integer  "clinical_trial_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "overall_officials", :force => true do |t|
    t.string   "name"
    t.string   "role"
    t.integer  "agency_id",  :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "overseers", :force => true do |t|
    t.integer  "clinical_trial_id", :limit => 11
    t.integer  "authority_id",      :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsors", :force => true do |t|
    t.integer  "agency_id",         :limit => 11
    t.integer  "clinical_trial_id", :limit => 11
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
