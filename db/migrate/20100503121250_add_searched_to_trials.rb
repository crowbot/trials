class AddSearchedToTrials < ActiveRecord::Migration
  def self.up
    add_column :clinical_trials, :searched, :boolean
  end

  def self.down
    remove_column :clinical_trials, :searched
  end
end
