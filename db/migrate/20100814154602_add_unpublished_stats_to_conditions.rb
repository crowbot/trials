class AddUnpublishedStatsToConditions < ActiveRecord::Migration
  def self.up
    add_column :conditions, :percent_unpublished_complete, :float
    add_column :conditions, :count_unpublished_complete, :integer
  end

  def self.down
    remove_column :conditions, :count_unpublished_complete
    remove_column :conditions, :percent_unpublished_complete
  end
end
