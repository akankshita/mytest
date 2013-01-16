class FixLocationEdgesBug < ActiveRecord::Migration
  def self.up
  	
  	execute "drop view gas_detail cascade"
  	execute "drop view electricity_detail cascade"
  	execute "drop view locations_edges cascade"
    execute "drop view electricity_edges cascade"  
    execute "drop view gas_edges cascade"        
  	
  	#location 
     execute "create view locations_edges as select node_entries.lft, node_entries.rgt, countries.id as country, regions.id as region, node_entries.name, locations.id as location_id from locations, countries, regions, node_entries where locations.region_id = regions.id and regions.country_id = countries.id and locations.id = node_entries.node_id and node_entries.node_type = 'Location';"
     
     
     #electricity 
     execute "create view electricity_edges as select electricity_readings.id, node_entries.lft, node_entries.rgt from electricity_readings, meters, node_entries where electricity_readings.meter_id = meters.id and meters.id = node_entries.node_id AND node_entries.node_type = 'Meter';"
     
     execute "create view electricity_detail as select electricity_edges.id, locations_edges.country, locations_edges.region, locations_edges.name, locations_edges.location_id as locations_id from locations_edges, electricity_edges where locations_edges.lft <= electricity_edges.lft AND locations_edges.rgt >= electricity_edges.rgt;"   
     
     
     #gas 
     execute "create view gas_edges as select gas_readings.id, node_entries.lft, node_entries.rgt from gas_readings, meters, node_entries where gas_readings.meter_id = meters.id and meters.id = node_entries.node_id AND node_entries.node_type = 'Meter';"
     
     execute "create view gas_detail as select gas_edges.id, locations_edges.country, locations_edges.region, locations_edges.name, locations_edges.location_id as locations_id from locations_edges, gas_edges where locations_edges.lft <= gas_edges.lft AND locations_edges.rgt >= gas_edges.rgt;" 
       
  end

  def self.down        
  end
end
