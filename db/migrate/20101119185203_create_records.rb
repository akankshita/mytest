class CreateRecords < ActiveRecord::Migration
  def self.up
    create_table :records do |t|
      t.references :activity 
      t.references :user 
      t.datetime :timestamp
      t.string :ip
      
      t.timestamps
    end
  end

  def self.down
    drop_table :records
  end
end
