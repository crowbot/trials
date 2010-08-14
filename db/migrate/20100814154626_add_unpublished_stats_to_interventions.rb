class AddUnpublishedStatsToInterventions < ActiveRecord::Migration
  def self.up
    add_column :interventions, :percent_unpublished_complete, :float
    add_column :interventions, :count_unpublished_complete, :integer
  end

  def self.down
    remove_column :interventions, :count_unpublished_complete
    remove_column :interventions, :percent_unpublished_complete
  end
end
