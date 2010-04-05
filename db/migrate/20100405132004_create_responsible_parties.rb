class CreateResponsibleParties < ActiveRecord::Migration
  def self.up
    create_table :responsible_parties do |t|
      t.string :name_title
      t.string :organization
      t.integer :clinical_trial_id
      t.timestamps
    end
  end

  def self.down
    drop_table :responsible_parties
  end
end
