class AddDatesToClinicalTrials < ActiveRecord::Migration
  def self.up
    add_column :clinical_trials, :verification_date, :string
    add_column :clinical_trials, :lastchanged_date, :string
    add_column :clinical_trials, :firstreceived_date, :string
  end

  def self.down
    remove_column :clinical_trials, :firstreceived_date
    remove_column :clinical_trials, :lastchanged_date
    remove_column :clinical_trials, :verification_date
  end
end
