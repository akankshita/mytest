class CreateSourceTypes < ActiveRecord::Migration
  def self.up
    create_table :source_types do |t|
      t.string :name
      t.timestamps
    end
    
    SourceType.create :name => "Gas Readings"
    SourceType.create :name => "Electrical Readings"
  end

  def self.down
    drop_table :source_types
  end
end
