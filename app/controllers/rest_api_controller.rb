class RestApiController < ApplicationController

  def send_data
    #This code is for demo, please burn after using
    current_user = User.first
    meter = Meter.first(:conditions => "source_type_id = 2")
    user = current_user
    now = DateTime.now

    electricity_reading = ElectricityReading.new(:meter_id => meter.id, :user_id => user.id, :end_time => now, :start_time => now, :mid_time => now, :electricity_value => 200)
    electricity_reading.save


  end

end
