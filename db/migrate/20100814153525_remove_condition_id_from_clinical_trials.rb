class RemoveConditionIdFromClinicalTrials < ActiveRecord::Migration
  def self.up
    remove_column :clinical_trials, :condition_id
  end

  def self.down
    add_column :clinical_trials, :condition_id, :integer
  end
end
