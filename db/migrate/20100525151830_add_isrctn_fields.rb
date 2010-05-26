class AddIsrctnFields < ActiveRecord::Migration
  def self.up
     add_column :clinical_trials, :isrctn_id, :string
     add_column :clinical_trials, :ethics_approval, :string     
     add_column :clinical_trials, :acronym, :string     
     add_column :clinical_trials, :disease_condition, :string
     add_column :clinical_trials, :inclusion_criteria, :text     
     add_column :clinical_trials, :exclusion_criteria, :text
     add_column :clinical_trials, :primary_outcome_measures, :text
     add_column :clinical_trials, :secondary_outcome_measures, :text     
     add_column :clinical_trials, :patient_info_material, :string
     add_column :clinical_trials, :funding_sources, :string
     add_column :clinical_trials, :trial_website, :string     
     add_column :clinical_trials, :publications, :string     
     add_column :clinical_trials, :date_isrctn_assigned, :string  
     add_column :clinical_trials, :interventions, :text 
     add_column :clinical_trials, :countries_of_recruitment, :string 
     
  end

  def self.down
    remove_column :clinical_trials, :isrctn_id
    remove_column :clinical_trials, :ethics_approval     
    remove_column :clinical_trials, :acronym     
    remove_column :clinical_trials, :disease_condition
    remove_column :clinical_trials, :inclusion_criteria     
    remove_column :clinical_trials, :exclusion_criteria
    remove_column :clinical_trials, :primary_outcome_measures
    remove_column :clinical_trials, :secondary_outcome_measures     
    remove_column :clinical_trials, :patient_info_material
    remove_column :clinical_trials, :funding_sources
    remove_column :clinical_trials, :trial_website     
    remove_column :clinical_trials, :publications     
    remove_column :clinical_trials, :date_isrctn_assigned
    remove_column :clinical_trials, :interventions
    remove_column :clinical_trials, :countries_of_recruitment
  end
end
