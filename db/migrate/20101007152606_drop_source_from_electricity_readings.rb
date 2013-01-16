class DropSourceFromElectricityReadings < ActiveRecord::Migration
  def self.up
    remove_column :electricity_readings, :source
  end

  def self.down
    add_column :electricity_readings, :source, :string
  end
end
