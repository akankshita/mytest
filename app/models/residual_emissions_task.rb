class ResidualEmissionsTask < ActiveRecord::Base
  belongs_to :footprint_report
  
  has_many :residual_emissions
end
