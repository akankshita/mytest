class CreateUnits < ActiveRecord::Migration
  def self.up
    create_table :units do |t|
      t.string :name

      t.timestamps
    end

    Unit.create(:name => "kWh")
    Unit.create(:name => "tonnes")
    Unit.create(:name => "litres")

  end

  def self.down
    drop_table :units
  end
end
