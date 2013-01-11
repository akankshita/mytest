class CreateGrowthMetricTasks < ActiveRecord::Migration
  def self.up
    create_table :growth_metric_tasks do |t|
      t.references :annual_report
      t.integer :status
      t.string :more_info
      t.float :turnover

      t.timestamps
    end
    annual_report = AnnualReport.first(:conditions => {:phase => 1})
    GrowthMetricTask.create(:annual_report_id => annual_report.id, :turnover => 0, :status => 0, :more_info => "This section deals with reporting your turnover for private organisations and revenue expenditure for public organisations.")
    ControllerDisplayName.create(:controller_name => GrowthMetricTasksController.controller_name, :display_name => "Growth Metrics")
    
  end

  def self.down
    drop_table :growth_metric_tasks
  end
end
