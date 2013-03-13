class OtherFuel < ActiveRecord::Base
  belongs_to :other_fuels_task
  belongs_to :unit
  
  validates_presence_of :description
  validates_presence_of :amount
  validates_numericality_of :amount
end
