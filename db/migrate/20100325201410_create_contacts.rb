class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :contact_type
      t.string :last_name
      t.string :phone
      t.string :phone_ext
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
