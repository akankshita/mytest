class AddSourceToElectricityReading < ActiveRecord::Migration
  def self.up
    add_column :electricity_readings, :source, :string
    
     ElectricityReading.all.each {|element|
        element.source = "SmartMeter A"
        element.save
      }
  end

  def self.down
    remove_column :electricity_readings, :source
  end
end
