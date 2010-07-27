class IndexSponsorsOnClinicalTrialId < ActiveRecord::Migration
  def self.up
    add_index :sponsors, :clinical_trial_id
    add_index :sponsors, :agency_id
  end

  def self.down
    remove_index :sponsors, :clinical_trial_id
    remove_index :sponsors, :agency_id
  end
end
