class CreateMeterGroups < ActiveRecord::Migration
  def self.up
    create_table :meter_groups do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :meter_groups
  end
end
