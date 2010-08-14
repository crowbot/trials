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

ActiveRecord::Schema.define(:version => 20100814154626) do

  create_table "agencies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "percent_unpublished_complete"
    t.integer  "count_unpublished_complete"
  end

  create_table "articles", :force => true do |t|
    t.integer  "pubmed_id"
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
    t.integer  "enrollment"
    t.string   "enrollment_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "why_stopped"
    t.integer  "number_of_arms"
    t.integer  "number_of_groups"
    t.integer  "overall_contact_id"
    t.integer  "overall_contact_backup_id"
    t.string   "verification_date"
    t.string   "lastchanged_date"
    t.string   "firstreceived_date"
    t.integer  "responsible_party_id"
    t.boolean  "searched"
    t.string   "isrctn_id"
    t.string   "ethics_approval"
    t.string   "acronym"
    t.string   "disease_condition"
    t.text     "inclusion_criteria"
    t.text     "exclusion_criteria"
    t.text     "primary_outcome_measures"
    t.text     "secondary_outcome_measures"
    t.string   "patient_info_material"
    t.string   "funding_sources"
    t.string   "trial_website"
    t.string   "publications"
    t.string   "date_isrctn_assigned"
    t.text     "interventions_description"
    t.string   "countries_of_recruitment"
    t.date     "completion_date_as_date"
    t.string   "nct_alias"
    t.datetime "download_date"
  end

  create_table "condition_trials", :force => true do |t|
    t.integer  "condition_id"
    t.integer  "clinical_trial_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conditions", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "percent_unpublished_complete"
    t.integer  "count_unpublished_complete"
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

  create_table "intervention_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interventions", :force => true do |t|
    t.integer  "intervention_type_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "percent_unpublished_complete"
    t.integer  "count_unpublished_complete"
  end

  create_table "investigators", :force => true do |t|
    t.string   "last_name"
    t.string   "role"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.integer  "facility_id"
    t.integer  "trial_id"
    t.string   "status"
    t.integer  "contact_id"
    t.integer  "backup_contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "outcomes", :force => true do |t|
    t.string   "outcome_type"
    t.string   "measure"
    t.string   "time_frame"
    t.string   "safety_issue"
    t.string   "description"
    t.integer  "clinical_trial_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "overall_officials", :force => true do |t|
    t.string   "name"
    t.string   "role"
    t.integer  "agency_id"
    t.integer  "clinical_trial_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "overseers", :force => true do |t|
    t.integer  "clinical_trial_id"
    t.integer  "authority_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "responsible_parties", :force => true do |t|
    t.string   "name_title"
    t.string   "organization"
    t.integer  "clinical_trial_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsors", :force => true do |t|
    t.integer  "agency_id"
    t.integer  "clinical_trial_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sponsors", ["agency_id"], :name => "index_sponsors_on_agency_id"
  add_index "sponsors", ["clinical_trial_id"], :name => "index_sponsors_on_clinical_trial_id"

  create_table "trial_interventions", :force => true do |t|
    t.integer  "clinical_trial_id"
    t.integer  "intervention_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trial_mentions", :force => true do |t|
    t.integer  "clinical_trial_id"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
