class CreateMeters < ActiveRecord::Migration
  def self.up
    create_table :meters do |t|
      t.string :meter_identifier
      t.string :type_of_meter

      t.timestamps
    end
  end

  def self.down
    drop_table :meters
  end
end
