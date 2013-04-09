class ImportcsvController < ApplicationController
  require 'rubygems'
  require 'open-uri'
  require 'csv'
  skip_before_filter :check_login,:only=>[:index,:process]
  

  
  def index
      ActiveRecord::Base.establish_connection(
      :adapter  => "postgresql",
      :host     => "ec2-54-243-180-196.compute-1.amazonaws.com",
      :port => 5432,
      :username => "lhyveujqjniwpk",
      :password =>"LHH3vRQcA6Bk3xMhPiUn6ZP3H6", 
      :database => "d5fad1g8mpuaha"
    )
       @current_meter_readings = MeterReading.find(:all,:conditions => ['csvinfo_id = ?',14])
      # render :text =>  @current_meter_readings.inspect and return false
       #ActiveRecord::Base.establish_connection('development')
       @current_meter_readings.each do |current_meter_reading|
          $time_diff = ((current_meter_reading.end_time - current_meter_reading.start_time)/60).round.to_i
         if $time_diff == 30
              ActiveRecord::Base.establish_connection('production')
              @electricity_reading = ElectricityReading.new
              @electricity_reading['electricity_value'] = current_meter_reading["usuage_value"]#@all_arr[1]
              @electricity_reading['meter_id'] = 3180#current_meter_reading["meter_ip"]#@all_arr[2]
              @electricity_reading['end_time'] = current_meter_reading["end_time"]#@all_arr[2]
              @electricity_reading['start_time'] = current_meter_reading["start_time"]#@all_arr[6]
              #render :text => current_meter_reading.inspect and return false
              @electricity_reading.save             
        else
         end
       end
       ActiveRecord::Base.establish_connection('development')
       render :text => 'ok' and return false
  end
end
