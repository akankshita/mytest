class EarlyActionMetricTask < ActiveRecord::Base
  belongs_to :annual_report
  belongs_to :scheme_provider
  
  validates_numericality_of :coverage, :less_than => 101, :greater_than => -1
  validates_numericality_of :voluntary_amr, :less_than => 101, :greater_than => -1

end
