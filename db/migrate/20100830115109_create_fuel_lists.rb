class CreateFuelLists < ActiveRecord::Migration
  def self.up
    create_table :fuel_lists do |t|
      t.string :fuel_name
      t.float :emission_factor
      t.boolean :residual
      t.references :residual_emission
      t.timestamps
    end
  end

  def self.down
    drop_table :fuel_lists
  end
end
