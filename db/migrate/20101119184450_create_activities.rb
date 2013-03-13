class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|

	  t.string :name
	  t.integer :security_level
	
      t.timestamps
    end
    
    execute "insert into activities (name,security_level) values ('logon', 0),('logoff',0),('failed_logon',0),('uploaded_electricity_file',0),('deleted_electricity_file',0),('uploaded_gas_file',0),('deleted_gas_file',0);"
  end

  def self.down
    drop_table :activities
  end
end
