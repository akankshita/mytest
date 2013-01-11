class DesignatedChange < ActiveRecord::Base
  belongs_to :designated_changes_task
  
  validates_presence_of     :text
  validates_presence_of     :date_of_change
end
