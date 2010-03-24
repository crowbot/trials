class AddWhyStoppedToClinicalTrials < ActiveRecord::Migration
  def self.up
    add_column :clinical_trials, :why_stopped, :string
  end

  def self.down
    remove_column :clinical_trials, :why_stopped
  end
end
