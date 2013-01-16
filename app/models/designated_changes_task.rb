class DesignatedChangesTask < ActiveRecord::Base
  belongs_to :footprint_report
  
  has_many :designated_changes
end
