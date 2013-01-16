class FixingBugInResidualEmissions < ActiveRecord::Migration
  def self.up
    remove_column :residual_emissions, :residual_emission_task_id
    add_column :residual_emissions, :residual_emissions_task_id, :integer
  end

  def self.down
    remove_column :residual_emissions, :residual_emissions_task_id
    add_column :residual_emissions, :residual_emission_task_id, :integer
  end
end
