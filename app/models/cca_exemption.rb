class CcaExemption < ActiveRecord::Base
belongs_to :cca_exemptions_task

  validates_presence_of :tui
  validates_presence_of :company_name
  validates_presence_of :emissions_covered
  
  validates_numericality_of :emissions_covered

end
