class CreateSponsors < ActiveRecord::Migration
  def self.up
    create_table :sponsors do |t|
      t.integer :agency_id
      t.integer :clinical_trial_id
      t.string :role

      t.timestamps
    end
  end

  def self.down
    drop_table :sponsors
  end
end
