class AddCtgResultsToClinicalTrials < ActiveRecord::Migration
  def self.up
    add_column :clinical_trials, :ctg_results, :boolean, :default => false
  end

  def self.down
    remove_column :clinical_trials, :ctg_results
  end
end
