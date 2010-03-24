class CreateAuthorities < ActiveRecord::Migration
  def self.up
    create_table :authorities do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :authorities
  end
end
