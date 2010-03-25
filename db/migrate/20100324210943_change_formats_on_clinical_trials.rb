class ChangeFormatsOnClinicalTrials < ActiveRecord::Migration
  def self.up
     change_column :clinical_trials, :start_date, :string
     change_column :clinical_trials, :end_date, :string
  end

  def self.down
    change_column :clinical_trials, :start_date, :date
    change_column :clinical_trials, :end_date, :date
  end
end
