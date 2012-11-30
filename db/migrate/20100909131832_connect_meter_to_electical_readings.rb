class ConnectMeterToElecticalReadings < ActiveRecord::Migration
  def self.up
    add_column :electricity_readings, :meter_id, :integer
    
    #populate meter id on all readings based on their upload id
    ElectricityReading.all.each {|reading|
      reading.meter = reading.electricity_upload.meter unless reading.electricity_upload == nil
      reading.save
    }
    
  end

  def self.down
    remove_column :electricity_readings, :meter_id
  end
end
