class AddContactsToClinicalTrials < ActiveRecord::Migration
  def self.up
    add_column :clinical_trials, :overall_contact_id, :integer
    add_column :clinical_trials, :overall_contact_backup_id, :integer
  end

  def self.down
    remove_column :clinical_trials, :overall_contact_backup_id
    remove_column :clinical_trials, :overall_contact_id
  end
end
