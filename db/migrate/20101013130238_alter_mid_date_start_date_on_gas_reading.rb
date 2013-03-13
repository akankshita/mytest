class AlterMidDateStartDateOnGasReading < ActiveRecord::Migration
  def self.up
    	execute "alter table gas_readings alter start_date type timestamp;"
    	execute "alter table gas_readings alter mid_date type timestamp;"
  end

  def self.down
  end
end
