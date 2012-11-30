class CreateElectricityReadings < ActiveRecord::Migration
  def self.up
    create_table :electricity_readings do |t|
      t.references :electricity_upload
      t.decimal :electricity_value, :precision => 32, :scale => 16
      t.datetime :electricity_timestamp

      t.timestamps
    end
  end

  def self.down
    drop_table :electricity_readings
  end
end
