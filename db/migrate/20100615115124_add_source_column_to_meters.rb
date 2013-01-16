class AddSourceColumnToMeters < ActiveRecord::Migration
  def self.up
    add_column :meters, :source_type_id, :integer
    remove_column :meters, :type_of_meter
  end

  def self.down
    remove_column :meters, :source_type_id
    add_column :meters, :type_of_meter, :string
  end
end
