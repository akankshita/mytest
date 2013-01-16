class CreateGasReadings < ActiveRecord::Migration
  def self.up
    create_table :gas_readings do |t|
      t.date :start_date
      t.date :end_date
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :gas_readings
  end
end
