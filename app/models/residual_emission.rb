class ResidualEmission < ActiveRecord::Base
  belongs_to :residual_emissions_task

  validates_presence_of :tonnes_c02
  validates_numericality_of :tonnes_c02
  
  has_one :fuel_list
end
