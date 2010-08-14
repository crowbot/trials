class AddPercentUnpublishedToAgencies < ActiveRecord::Migration
  def self.up
    add_column :agencies, :percent_unpublished_complete, :float
  end

  def self.down
    remove_column :agencies, :percent_unpublished_complete
  end
end
