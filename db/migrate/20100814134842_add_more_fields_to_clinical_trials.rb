class AddMoreFieldsToClinicalTrials < ActiveRecord::Migration
  def self.up
    add_column :clinical_trials, :nct_alias, :string
    add_column :clinical_trials, :download_date, :datetime
  end

  def self.down
    remove_column :clinical_trials, :download_date
    remove_column :clinical_trials, :nct_alias
  end
end
