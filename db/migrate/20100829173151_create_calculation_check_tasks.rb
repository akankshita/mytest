class CreateCalculationCheckTasks < ActiveRecord::Migration
  def self.up
    create_table :calculation_check_tasks do |t|
      t.integer :status
      t.boolean :in_order
      
      t.text :more_info
      t.references :footprint_report
      t.timestamps
    end
    
    footprint_report = FootprintReport.first(:conditions => {:phase => 1})
    CalculationCheckTask.create :footprint_report_id => footprint_report.id, :more_info => "<Placeholder for more info>", :status => 0,  :in_order => 0
    
  end

  def self.down
    drop_table :calculation_check_tasks
  end
end
