class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.integer :facility_id
      t.integer :trial_id
      t.string :status
      t.integer :contact_id
      t.integer :backup_contact_id

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
