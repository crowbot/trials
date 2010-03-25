class CreateOverallOfficials < ActiveRecord::Migration
  def self.up
    create_table :overall_officials do |t|
      t.string :name
      t.string :role
      t.integer :agency_id

      t.timestamps
    end
  end

  def self.down
    drop_table :overall_officials
  end
end
