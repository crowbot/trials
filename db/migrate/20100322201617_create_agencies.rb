class CreateAgencies < ActiveRecord::Migration
  def self.up
    create_table :agencies do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :agencies
  end
end
