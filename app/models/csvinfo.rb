class Csvinfo < ActiveRecord::Base
  attr_accessible :customer_id, :name,:verified,:loaded,:totaldata,:view,:status,:upload_date
  has_many :customers,:dependent => :destroy
  belongs_to :meter_reading
end
