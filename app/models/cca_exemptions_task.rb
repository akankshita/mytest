class CcaExemptionsTask < ActiveRecord::Base
  belongs_to :footprint_report

  has_many :cca_exemptions
end
