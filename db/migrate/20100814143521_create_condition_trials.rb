class CreateConditionTrials < ActiveRecord::Migration
  def self.up
    create_table :condition_trials do |t|
      t.integer :condition_id
      t.integer :clinical_trial_id

      t.timestamps
    end
  end

  def self.down
    drop_table :condition_trials
  end
end
