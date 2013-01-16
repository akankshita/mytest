class AddViewForGasReadingsEdges < ActiveRecord::Migration
  def self.up
    execute "create view gas_edges as select gas_readings.id, node_entries.lft, node_entries.rgt from gas_readings, meters, node_entries where gas_readings.meter_id = meters.id and meters.id = node_entries.node_id AND node_entries.node_type = 'Meter';"
    execute "create view gas_detail as select gas_edges.id, locations_edges.country, locations_edges.region, locations_edges.name from locations_edges, gas_edges where locations_edges.lft <= gas_edges.lft AND locations_edges.rgt >= gas_edges.rgt;"     
  end

  def self.down

  end
end
