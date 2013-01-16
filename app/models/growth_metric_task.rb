class GrowthMetricTask < ActiveRecord::Base
  belongs_to :annual_report
  
  validates_numericality_of :turnover, :greater_than => -1
end
