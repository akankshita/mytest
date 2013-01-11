require 'time_utils'

class GasReading < ActiveRecord::Base
  attr_reader :per_page
  @@per_page = 10
  
  validates_presence_of :gas_value, :start_time, :end_time, :meter
  validates_numericality_of :gas_value    
  
  belongs_to :user
  belongs_to :meter
  belongs_to :gas_upload
  
  def validate
    if(start_time != nil and end_time != nil)
      errors.add(:start_time, "must be after End time") if start_time >= end_time 
    end
  end
  
  def find_time_stamp_in_js
    result = TimeUtils.convert_to_js_timestamp(self.mid_time)
  end
  
  def plot_value
    self.gas_value
  end
  
  def timestamp
    self.end_time
  end
  
end
