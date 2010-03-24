class CreateClinicalTrials < ActiveRecord::Migration
  def self.up
    create_table :clinical_trials do |t|
      t.string :url
      t.string :nct_id
      t.string :org_study_id
      t.string :secondary_ids
      t.string :brief_title
      t.string :official_title
      t.string :source
      t.boolean :has_data_monitoring_committee
      t.text :summary
      t.string :overall_status
      t.date :start_date
      t.date :end_date
      t.string :completion_date
      t.string :completion_date_type
      t.string :primary_completion_date
      t.string :primary_completion_date_type
      t.string :phase
      t.string :study_type
      t.string :study_design
      t.integer :enrollment
      t.string :enrollment_type
      t.integer :condition_id

      t.timestamps
    end
  end

  def self.down
    drop_table :clinical_trials
  end
end
