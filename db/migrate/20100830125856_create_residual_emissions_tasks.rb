class CreateResidualEmissionsTasks < ActiveRecord::Migration
  def self.up
    create_table :residual_emissions_tasks do |t|
      t.references :footprint_report
      t.integer :status
      t.text :more_info
	  t.date :deadline 

      t.timestamps
    end
        
    deadline_date = Date.civil(2011, 7, 31)
    footprint_report = FootprintReport.first(:conditions => {:phase => 1})
    ResidualEmissionsTask.create :footprint_report_id => footprint_report.id, :deadline => deadline_date, :more_info => "<Placeholder for more info>", :status => 0 
    
  end

  def self.down
    drop_table :residual_emissions_tasks
  end
end
