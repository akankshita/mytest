class SignificantGroupUndertaking < ActiveRecord::Base
  belongs_to :significant_group_undertakings_task
  
  validates_presence_of :name, :carbon_emitted
  validates_numericality_of :carbon_emitted
   
end
