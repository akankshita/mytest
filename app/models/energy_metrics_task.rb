class EnergyMetricsTask < ActiveRecord::Base
  belongs_to :footprint_report
  
  validates_presence_of :core_electricity
  validates_presence_of :core_gas
  validates_presence_of :non_core_electricity
  validates_presence_of :non_core_gas
  validates_presence_of :aviation_spirit
  validates_presence_of :blast_furnace_gas
  validates_presence_of :burning_fuels
  validates_presence_of :coke_oven_gas
  validates_presence_of :colliery_methane
  validates_presence_of :diesel
  validates_presence_of :fuel_oil
  validates_presence_of :gas_oil
  validates_presence_of :industrial_coal
  validates_presence_of :LPG
  validates_presence_of :lubricants
  validates_presence_of :waste
  validates_presence_of :naphtha
  validates_presence_of :natural_gas
  validates_presence_of :petrol_gas
  validates_presence_of :petrol
  
  validates_numericality_of :core_electricity
  validates_numericality_of :core_gas
  validates_numericality_of :non_core_electricity
  validates_numericality_of :non_core_gas
  validates_numericality_of :aviation_spirit
  validates_numericality_of :blast_furnace_gas
  validates_numericality_of :burning_fuels
  validates_numericality_of :coke_oven_gas
  validates_numericality_of :colliery_methane
  validates_numericality_of :diesel
  validates_numericality_of :fuel_oil
  validates_numericality_of :gas_oil
  validates_numericality_of :industrial_coal
  validates_numericality_of :LPG
  validates_numericality_of :lubricants
  validates_numericality_of :waste
  validates_numericality_of :naphtha
  validates_numericality_of :natural_gas
  validates_numericality_of :petrol_gas
  validates_numericality_of :petrol
  
end
