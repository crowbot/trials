class AddCompletionDateAsDateToTrials < ActiveRecord::Migration
  def self.up
    add_column :clinical_trials, :completion_date_as_date, :date
  end

  def self.down
    remove_column :clinical_trials, :completion_date_as_date
  end
end
