class AddCountUnpublishedCompleteToAgencies < ActiveRecord::Migration
  def self.up
    add_column :agencies, :count_unpublished_complete, :integer
  end

  def self.down
    remove_column :agencies, :count_unpublished_complete
  end
end
