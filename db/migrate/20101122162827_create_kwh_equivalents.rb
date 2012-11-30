class CreateKwhEquivalents < ActiveRecord::Migration
  def self.up
    create_table :kwh_equivalents do |t|
      t.references :source_type
      t.string :name
      t.float :conversion_factor

      t.timestamps
    end
    
    t = Time.now.to_s(:db)
    elec_source_id = SourceType.all(:conditions=>"name = 'Electrical Readings'").first.id
	    
    execute "insert INTO kwh_equivalents (source_type_id, name, conversion_factor,created_at) values (#{elec_source_id}, 'kW/h', 1.0, '#{t}' ), (#{elec_source_id}, 'British Thermal Unit',3413, '#{t}'), (#{elec_source_id}, 'Foot-pounds', 2.655e6 , '#{t}'), (#{elec_source_id},'Joules', 3.6e6, '#{t}'), (#{elec_source_id},'Kilo-calories', 859.8, '#{t}')"
    
    
    gas_source_id = SourceType.all(:conditions=>"name = 'Gas Readings'").first.id
    
    execute "insert into kwh_equivalents (source_type_id, name, conversion_factor, created_at) values (#{gas_source_id}, 'kW/h', 1.0, '#{t}' ), (#{gas_source_id}, 'metres cubed (m3)', 11.02, '#{t}')"

    
  end

  def self.down
    drop_table :kwh_equivalents
  end
end
