class ModifyFuelListTable < ActiveRecord::Migration
  def self.up
    remove_column :fuel_lists, :residual
    rename_column :fuel_lists, :emission_factor, :emission_factor_v1 
    
  
    #fuel list (page 12 'table of conversion factors')
    FuelList.create(:fuel_name => "aviation_spirit", :emission_factor_v1 => 1)
    FuelList.create(:fuel_name => "aviation_turbine", :emission_factor_v1 => 1)
    FuelList.create(:fuel_name => "BOS_gas", :emission_factor_v1 => 1)
    FuelList.create(:fuel_name => "blast_furnace_gas", :emission_factor_v1 => 1)
    FuelList.create(:fuel_name => "cement_industry_coal", :emission_factor_v1 => 1)
    FuelList.create(:fuel_name => "commercial_public_coal", :emission_factor_v1 => 1)
    FuelList.create(:fuel_name => "coking_coal", :emission_factor_v1 => 1)
    FuelList.create(:fuel_name => "colliery_methane", :emission_factor_v1 => 1)
    FuelList.create(:fuel_name => "diesel", :emission_factor_v1 => 1)
    FuelList.create(:fuel_name => "lignite", :emission_factor_v1 => 1)
    FuelList.create(:fuel_name => "peat", :emission_factor_v1 => 1)
    FuelList.create(:fuel_name => "petroleum_coke", :emission_factor_v1 => 1)
    FuelList.create(:fuel_name => "scrap_tyres", :emission_factor_v1 => 1)
    FuelList.create(:fuel_name => "solid_smokeless_fuel", :emission_factor_v1 => 1)
    FuelList.create(:fuel_name => "sour_gas", :emission_factor_v1 => 1)
    FuelList.create(:fuel_name => "waste", :emission_factor_v1 => 1)
    FuelList.create(:fuel_name => "waste_oil", :emission_factor_v1 => 1)
    FuelList.create(:fuel_name => "waste_solvents", :emission_factor_v1 => 1)
    
  end

  def self.down
    add_column :fuel_lists, :residual
    rename_column :fuel_lists, :emission_factor_v1, :emission_factor
  end
end
