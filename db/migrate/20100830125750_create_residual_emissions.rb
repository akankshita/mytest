class CreateResidualEmissions < ActiveRecord::Migration
  def self.up
    create_table :residual_emissions do |t|
      t.float :tonnes_c02

      t.references :residual_emission_task
      t.timestamps
    end
  end

  def self.down
    drop_table :residual_emissions
  end
end
