class CreateTariffs < ActiveRecord::Migration
  def self.up
    create_table :tariffs do |t|
      t.float :day_rate
      t.float :night_rate

      t.timestamps
    end

    #default tarrif rates, make sure you overwrite this with the appropriate values
     Tariff.create :day_rate => "0.1255", :night_rate => "0.0675"
     
  end

  def self.down
    drop_table :tariffs
  end
end
