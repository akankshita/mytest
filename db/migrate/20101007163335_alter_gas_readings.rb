class AlterGasReadings < ActiveRecord::Migration
  def self.up
  	execute "alter table gas_readings alter end_date type timestamp;"
  end

  def self.down
  end
end
