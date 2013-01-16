class CreateDesignatedChangesTasks < ActiveRecord::Migration
  def self.up
    create_table :designated_changes_tasks do |t|
      t.date :deadline
      t.integer :status
      t.string :more_info
      t.references :footprint_report

      t.timestamps
    end
    
    deadline_date = Date.civil(2011, 7, 31)
    footprint_report = FootprintReport.first(:conditions => {:phase => 1})
    DesignatedChangesTask.create :footprint_report_id => footprint_report.id, :deadline => deadline_date, :more_info => "<Placeholder for more info>", :status => 0 
    
  end

  def self.down
    drop_table :designated_changes_tasks
  end
end
