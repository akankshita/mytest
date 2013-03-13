class FootprintReport < ActiveRecord::Base
  validates_presence_of     :phase
  validates_uniqueness_of   :phase
  validates_presence_of     :deadline
  validates_presence_of     :title
  validates_uniqueness_of   :title
  
  has_one :designated_changes_task
  has_one :cca_exemptions_task
  has_one :reconfirmation_exemption_task
  has_one :energy_metrics_task
  has_one :emission_metrics_task
  has_one :calculation_check_task
  has_one :residual_emissions_task
  has_one :other_fuels_task
  
end
