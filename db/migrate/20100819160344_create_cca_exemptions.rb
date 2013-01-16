class CreateCcaExemptions < ActiveRecord::Migration
  def self.up
    create_table :cca_exemptions do |t|
      t.string :tui
      t.string :company_name
      t.float :emissions_covered
      t.references :cca_exemptions_task
    
      t.timestamps
    end
  end

  def self.down
    drop_table :cca_exemptions
  end
end
