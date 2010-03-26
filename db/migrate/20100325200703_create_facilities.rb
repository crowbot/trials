class CreateFacilities < ActiveRecord::Migration
  def self.up
    create_table :facilities do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :country
      t.string :zip
      t.timestamps
    end
  end

  def self.down
    drop_table :facilities
  end
end
