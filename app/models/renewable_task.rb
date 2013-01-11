class RenewableTask < ActiveRecord::Base
  belongs_to :annual_report
  has_many :renewables
end
