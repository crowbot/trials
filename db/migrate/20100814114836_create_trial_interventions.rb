class CreateTrialInterventions < ActiveRecord::Migration
  def self.up
    create_table :trial_interventions do |t|
      t.integer :clinical_trial_id
      t.integer :intervention_id

      t.timestamps
    end
  end

  def self.down
    drop_table :trial_interventions
  end
end
