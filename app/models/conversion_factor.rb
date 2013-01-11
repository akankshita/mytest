class ConversionFactor < ActiveRecord::Base
  validates_presence_of :rate
  validates_numericality_of :rate
end
