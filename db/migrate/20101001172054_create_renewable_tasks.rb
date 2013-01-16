class CreateRenewableTasks < ActiveRecord::Migration
  def self.up
    create_table :renewable_tasks do |t|
      t.integer :status
      t.string :more_info
      t.date :deadline
      t.references :annual_report

      t.timestamps
    end
    
    deadline_date = Date.civil(2011, 7, 31)
    annual_report = AnnualReport.first(:conditions => {:phase => 1})
    RenewableTask.create :annual_report_id => annual_report.id, :deadline => deadline_date, :more_info => "<Placeholder for more info>", :status => 0  
    
  end

  def self.down
    drop_table :renewable_tasks
  end
end
