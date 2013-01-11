class CreateOtherFuels < ActiveRecord::Migration
  def self.up
    create_table :other_fuels do |t|
      t.references :other_fuels_task
      t.string :description
      t.float :amount
      t.references :unit 

      t.timestamps
    end
  end

  def self.down
    drop_table :other_fuels
  end
end
