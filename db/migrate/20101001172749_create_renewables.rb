class CreateRenewables < ActiveRecord::Migration
  def self.up
    create_table :renewables do |t|
    t.references :renewable_task
	  t.float :roc
	  t.float :fit
	  t.float :renewablesGenerated

      t.timestamps
    end
    
    Renewable.create :roc => 0.0, :fit => 0.0, :renewablesGenerated => 0.0
    
  end

  def self.down
    drop_table :renewables
  end
end
