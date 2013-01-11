class FillingOutRenewablesMoreInfo < ActiveRecord::Migration
  def self.up
    annual_report = AnnualReport.first(:conditions => {:phase => 1})
    old_renewables = annual_report.renewable_task
    old_renewables.delete
    Renewable.all.each {|e| e.delete}
    
    deadline_date = Date.civil(2011, 7, 31)
    renewable_task = RenewableTask.create :annual_report_id => annual_report.id, :deadline => deadline_date, :more_info => "This section is used to report what energy you have generated or received from a renewable source that falls under a ROC or FIT programme", :status => 0  
    Renewable.create :roc => 0.0, :fit => 0.0, :renewablesGenerated => 0.0, :renewable_task_id => renewable_task.id
  end

  def self.down
  end
end
