class CreateElectricityGeneratingCreditsTasks < ActiveRecord::Migration
  def self.up
    create_table :electricity_generating_credits_tasks do |t|
      t.integer :credits
      t.string :more_info
      t.integer :status
      t.references :annual_report
      t.timestamps
    end
    deadline_date = Date.civil(2011, 7, 31)
    annual_report = AnnualReport.first(:conditions => {:phase => 1})
    ElectricityGeneratingCreditsTask.create :annual_report_id => annual_report.id, :more_info => "Report how many credits you have received due to generating electricity.", :status => 0, :credits => 0  
    ControllerDisplayName.create(:controller_name => ElectricityGeneratingCreditsTasksController.controller_name, :display_name => "Electricity generating credits")
  end

  def self.down
    drop_table :electricity_generating_credits_tasks
  end
end
