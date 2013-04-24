class AddFieldConvesionFactor < ActiveRecord::Migration
  def self.up
    add_column :conversion_factors, :country_id, :integer
  end

  def self.down
    remove_column :conversion_factors, :country_id
  end
end
