class ChangeElectricalUploadToHaveMeter < ActiveRecord::Migration
  def self.up
    add_column :electricity_uploads, :meter_id, :integer
  end

  def self.down
    remove_column :electricity_uploads, :meter_id
  end
end
