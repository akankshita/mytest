class EmissionMetricsTask < ActiveRecord::Base
  belongs_to :footprint_report
  validates_presence_of :core_energy_ETS
  validates_presence_of :non_core_energy_ETS
  validates_presence_of :cca_subsidiaries
  validates_presence_of :cca_core_energy
  validates_presence_of :cca_non_core_energy
  validates_presence_of :electricity_generated_credit
  validates_presence_of :renewables_generation
  
  validates_numericality_of :core_energy_ETS
  validates_numericality_of :non_core_energy_ETS
  validates_numericality_of :cca_subsidiaries
  validates_numericality_of :cca_core_energy
  validates_numericality_of :cca_non_core_energy
  validates_numericality_of :electricity_generated_credit
  validates_numericality_of :renewables_generation
  
end
