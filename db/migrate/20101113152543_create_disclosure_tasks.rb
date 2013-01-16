class CreateDisclosureTasks < ActiveRecord::Migration
  def self.up
    create_table :disclosure_tasks do |t|
      t.references :annual_report
      t.string :more_info
      t.integer :status
      t.integer :question_1
      t.integer :question_2
      t.integer :question_3
      t.integer :question_4

      t.timestamps
    end  
    annual_report = AnnualReport.first(:conditions => {:phase => 1})
    DisclosureTask.create :annual_report_id => annual_report.id, :question_1 => 2, :question_2 => 2, :question_3 => 2, :question_4 => 2, :more_info => "In this section you have to answer some optional questions relating to actions your organisation has taken regarding carbon emissions reduction.", :status => 0  
    ControllerDisplayName.create(:controller_name => ConfirmEnergySupplyTaskController.controller_name, :display_name => "Confirm Energy Supply")
  end

  def self.down
    drop_table :disclosure_tasks
  end
end
