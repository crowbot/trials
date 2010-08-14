class RenameInterventionsToInterventionsDescription < ActiveRecord::Migration
  def self.up
    rename_column :clinical_trials, :interventions, :interventions_description
  end

  def self.down
    rename_column :clinical_trials, :interventions_description, :interventions
  end
end
