class CreateOtherFuelsTasks < ActiveRecord::Migration
  def self.up
    create_table :other_fuels_tasks do |t|
      t.integer :status
      t.references :footprint_report
	  t.text :more_info
      t.timestamps
    end
    
    footprint_report = FootprintReport.first(:conditions => {:phase => 1})
    OtherFuelsTask.create :footprint_report_id => footprint_report.id, :more_info => "<Placeholder for more other_fuel  info>", :status => 0
    
  end

  def self.down
    drop_table :other_fuels_tasks
  end
end
