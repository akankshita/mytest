class AddGasValueToGasReadings < ActiveRecord::Migration
  def self.up
    add_column :gas_readings, :gas_value, :decimal, :precision => 32, :scale => 16
  end

  def self.down
    remove_column :gas_readings, :gas_value
  end
end
