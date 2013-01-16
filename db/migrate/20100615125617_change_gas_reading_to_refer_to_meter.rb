class ChangeGasReadingToReferToMeter < ActiveRecord::Migration
  def self.up
    add_column :gas_readings, :meter_id, :integer
  end

  def self.down
    remove_column :gas_readings, :meter_id
  end
end
