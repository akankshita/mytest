class CreateEarlyActionMetricTasks < ActiveRecord::Migration
  def self.up
    create_table :early_action_metric_tasks do |t|
      t.references :annual_report
      t.integer :status
      t.string :more_info
      t.integer :coverage
      t.references :scheme_provider
      t.integer :voluntary_amr

      t.timestamps
    end
    
    annual_report = AnnualReport.first(:conditions => {:phase => 1})
    EarlyActionMetricTask.create(:annual_report_id => annual_report.id, :status => 0, :more_info => "This section deals with outlining what steps you have already taken to reduce your carbon emissions", :coverage => 0, :voluntary_amr => 0)
    ControllerDisplayName.create(:controller_name => EarlyActionMetricTasksController.controller_name, :display_name => "Early Action Metrics")
    
  end

  def self.down
    drop_table :early_action_metric_tasks
  end
end
