class CreateSignificantGroupUndertakings < ActiveRecord::Migration
  def self.up
    create_table :significant_group_undertakings do |t|
      t.references :significant_group_undertakings_task
      t.string :name
      t.float :carbon_emitted

      t.timestamps
    end
  end

  def self.down
    drop_table :significant_group_undertakings
  end
end
