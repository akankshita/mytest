class AddMidDateToGasReading < ActiveRecord::Migration
  def self.up
    add_column :gas_readings, :mid_date, :date
    
    GasReading.all.each {|element|
      element.mid_date = TimeUtils.find_mid_time(element.start_date, element.end_date)
      element.save
    }
  end

  def self.down
    remove_column :gas_readings, :mid_date
  end
end
