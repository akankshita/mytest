class AnnualReport < ActiveRecord::Base

  validates_presence_of     :phase
  validates_uniqueness_of   :phase
  validates_presence_of     :deadline
  validates_presence_of     :title
  validates_uniqueness_of   :title

  has_one :renewable_task
  has_one :confirm_energy_supply_task
  has_one :electricity_generating_credits_task
  has_one :report_other_fuels_task
  has_one :significant_group_undertakings_task
  has_one :early_action_metric_task
  has_one :growth_metric_task
  has_one :disclosure_task

end
