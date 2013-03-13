class CreateConfirmEnergySupplyTasks < ActiveRecord::Migration
  def self.up
    create_table :confirm_energy_supply_tasks do |t|
    t.integer :status
    t.boolean :is_confirmed
    t.references :annual_report
    t.string :more_info
    t.timestamps
    end
    deadline_date = Date.civil(2011, 7, 31)
    annual_report = AnnualReport.first(:conditions => {:phase => 1})
    ConfirmEnergySupplyTask.create :annual_report_id => annual_report.id, :more_info => "Confirm that you have uploaded all core electricity and gas usage data for the period of this report.", :status => 0  
    ControllerDisplayName.create(:controller_name => ConfirmEnergySupplyTaskController.controller_name, :display_name => "Confirm Energy Supply")
  end

  def self.down
    drop_table :confirm_energy_supply_tasks
  end
end
