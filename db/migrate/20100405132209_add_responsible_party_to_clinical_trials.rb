class AddResponsiblePartyToClinicalTrials < ActiveRecord::Migration
  def self.up
    add_column :clinical_trials, :responsible_party_id, :integer
  end

  def self.down
    remove_column :clinical_trials, :responsible_party_id
  end
end
