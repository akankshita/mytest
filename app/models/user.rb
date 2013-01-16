class User < ActiveRecord::Base
  acts_as_authentic

  has_many :gas_readings
  has_many :electricity_uploads
  has_many :document_uploads
  has_many :electricity_configs
  has_many :gas_uploads
  has_many :electricity_readings
  has_many :records
  has_many :support_tickets

end
