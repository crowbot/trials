class CreateOverseers < ActiveRecord::Migration
  def self.up
    create_table :overseers do |t|
      t.integer :clinical_trial_id
      t.integer :authority_id

      t.timestamps
    end
  end

  def self.down
    drop_table :overseers
  end
end
