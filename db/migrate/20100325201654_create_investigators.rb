class CreateInvestigators < ActiveRecord::Migration
  def self.up
    create_table :investigators do |t|
      t.string :last_name
      t.string :role
      t.integer :location_id

      t.timestamps
    end
  end

  def self.down
    drop_table :investigators
  end
end
