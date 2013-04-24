class MeterReading < ActiveRecord::Base
  attr_accessible :csvinfo_id, :meter_ip,:meter_id,:usuage_value,:start_time,:end_time,:kwh,:customer_id
  has_many :csvinfos,:dependent => :destroy
end
