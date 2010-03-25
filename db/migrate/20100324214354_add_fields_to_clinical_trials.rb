class AddFieldsToClinicalTrials < ActiveRecord::Migration
  def self.up
    add_column :clinical_trials, :number_of_arms, :integer
    add_column :clinical_trials, :number_of_groups, :integer
  end

  def self.down
    remove_column :clinical_trials, :number_of_groups
    remove_column :clinical_trials, :number_of_arms
  end
end
