class ChangeElectrictyReadingToMatchGasReading < ActiveRecord::Migration
  def self.up
    rename_column :electricity_readings, :electricity_timestamp, :end_time
    add_column :electricity_uploads, :interval, :integer
    ElectricityReading.find_by_sql("UPDATE electricity_uploads SET interval = 30")
    add_column :electricity_readings, :start_time, :datetime
    add_column :electricity_readings, :mid_time, :datetime
    add_column :electricity_readings, :user_id, :integer
    ElectricityReading.all.each{|reading|
      if(reading.start_time.nil?)
        reading.start_time = reading.end_time - (reading.electricity_upload.interval * 60)
        reading.mid_time = TimeUtils.find_mid_time(reading.start_time, reading.end_time)
        reading.user_id = reading.electricity_upload.user_id
        reading.save
      end
    }
  end

  def self.down
    rename_column :electricity_readings, :end_time, :electricity_timestamp
    remove_column :electricity_uploads, :interval
    remove_column :electricity_readings, :start_time
    remove_column :electricity_readings, :mid_time
    remove_column :electricity_readings, :user_id
  end
end
