class ReconfirmationExemptionTask < ActiveRecord::Base
  belongs_to :footprint_report
  
  validates_presence_of :choice
end
