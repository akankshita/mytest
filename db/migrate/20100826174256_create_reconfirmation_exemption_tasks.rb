class CreateReconfirmationExemptionTasks < ActiveRecord::Migration
  def self.up
    create_table :reconfirmation_exemption_tasks do |t|
      t.integer :choice
      t.integer :status
      t.references :footprint_report
      t.text :more_info
      t.timestamps
    end
    
    footprint_report = FootprintReport.first(:conditions => {:phase => 1})
   ReconfirmationExemptionTask.create :footprint_report_id => footprint_report.id, :more_info => "<Placeholder for more info>", :status => 0, :choice => 1

  end

  def self.down
    drop_table :reconfirmation_exemption_tasks
  end
end
