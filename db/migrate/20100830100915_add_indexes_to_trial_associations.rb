class AddIndexesToTrialAssociations < ActiveRecord::Migration
  def self.up
    add_index :trial_interventions, :intervention_id
    add_index :trial_interventions, :clinical_trial_id
    add_index :condition_trials, :condition_id
    add_index :condition_trials, :clinical_trial_id
    add_index :overall_officials, :agency_id
    add_index :overall_officials, :clinical_trial_id
    add_index :trial_mentions, :article_id
    add_index :trial_mentions, :clinical_trial_id
    add_index :responsible_parties, :clinical_trial_id
    add_index :overseers, :authority_id
    add_index :overseers, :clinical_trial_id
  end

  def self.down
    remove_index :trial_interventions, :intervention_id
    remove_index :trial_interventions, :clinical_trial_id
    remove_index :condition_trials, :condition_id
    remove_index :condition_trials, :clinical_trial_id
    remove_index :overall_officials, :agency_id
    remove_index :overall_officials, :clinical_trial_id
    remove_index :trial_mentions, :article_id
    remove_index :trial_mentions, :clinical_trial_id
    remove_index :responsible_parties, :clinical_trial_id
    remove_index :overseers, :authority_id
    remove_index :overseers, :clinical_trial_id
  end
end
