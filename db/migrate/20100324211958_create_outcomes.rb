class CreateOutcomes < ActiveRecord::Migration
  def self.up
    create_table :outcomes do |t|
      t.string :outcome_type
      t.string :measure
      t.string :time_frame
      t.string :safety_issue
      t.string :description
      t.integer :clinical_trial_id

      t.timestamps
    end
  end

  def self.down
    drop_table :outcomes
  end
end
