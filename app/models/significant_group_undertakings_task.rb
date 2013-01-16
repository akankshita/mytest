class SignificantGroupUndertakingsTask < ActiveRecord::Base
  belongs_to :annual_report
  has_many :significant_group_undertakings
end
