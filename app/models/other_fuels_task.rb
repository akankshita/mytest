class OtherFuelsTask < ActiveRecord::Base
  belongs_to :footprint_report
  has_many :other_fuels
end
