class CreateEnergyMetricsTasks < ActiveRecord::Migration
  def self.up
    create_table :energy_metrics_tasks do |t|
      t.references :footprint_report

      t.float    "core_electricity"
      t.float    "core_gas"
      t.float    "non_core_electricity"
      t.float    "non_core_gas"
      t.float    "aviation_spirit"
      t.float    "blast_furnace_gas"
      t.float    "burning_fuels"
      t.float    "coke_oven_gas"
      t.float    "colliery_methane"
      t.float    "diesel"
      t.float    "fuel_oil"
      t.float    "gas_oil"
      t.float    "industrial_coal"
      t.float    "LPG"
      t.float    "lubricants"
      t.float    "waste"
      t.float    "naphtha"
      t.float    "natural_gas"
      t.float    "petrol_gas"
      t.float    "petrol"

      t.text :more_info
      t.integer  "status"
      t.timestamps
     end
          
      footprint_report = FootprintReport.first(:conditions => {:phase => 1})
      EnergyMetricsTask.create :footprint_report_id => footprint_report.id, :more_info => "<Placeholder for more info>", :status => 0, :core_electricity => 0.0, :core_gas => 0.0, :non_core_electricity => 0.0,       :non_core_gas => 0.0,       :aviation_spirit => 0.0, :blast_furnace_gas => 0.0,      :burning_fuels => 0.0,       :coke_oven_gas => 0.0,      :colliery_methane => 0.0,       :diesel => 0.0,       :fuel_oil=> 0.0,       :gas_oil => 0.0,       :industrial_coal=> 0.0,       :LPG => 0.0,       :lubricants =>0.0,       :waste => 0.0,       :naphtha => 0.0,      :natural_gas => 0.0,       :petrol_gas => 0.0,       :petrol =>0.0
      
  end

  def self.down
    drop_table :energy_metrics_tasks
  end
end
