class CreateEmissionMetricsTasks < ActiveRecord::Migration
  def self.up
    create_table :emission_metrics_tasks do |t|
      t.float :core_energy_ETS
      t.float :non_core_energy_ETS
      t.float :cca_subsidiaries
      t.float :cca_core_energy
      t.float :cca_non_core_energy
      t.float :electricity_generated_credit
      t.float :renewables_generation
      
      t.text :more_info
      t.integer :status
      t.references :footprint_report

      t.timestamps
    end
    
    footprint_report = FootprintReport.first(:conditions => {:phase => 1})
    EmissionMetricsTask.create :footprint_report_id => footprint_report.id, :more_info => "<Placeholder for more info>", :status => 0,  :core_energy_ETS => 0, :non_core_energy_ETS => 0, :cca_subsidiaries => 0,  :cca_core_energy => 0, :cca_non_core_energy => 0, :electricity_generated_credit => 0,  :renewables_generation => 0
    
  end

  def self.down
    drop_table :emission_metrics_tasks
  end
end
