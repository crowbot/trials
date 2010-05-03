class CreateTrialMentions < ActiveRecord::Migration
  def self.up
    create_table :trial_mentions do |t|
      t.integer :clinical_trial_id
      t.integer :article_id

      t.timestamps
    end
  end

  def self.down
    drop_table :trial_mentions
  end
end
