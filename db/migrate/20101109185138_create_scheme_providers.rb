class CreateSchemeProviders < ActiveRecord::Migration
  def self.up
    create_table :scheme_providers do |t|
      t.string :name
      t.timestamps
    end
    SchemeProvider.create(:name => "Carbon Trust Standard")
    SchemeProvider.create(:name => "CEMARS")
    SchemeProvider.create(:name => "BSI Kitemark")
  end

  def self.down
    drop_table :scheme_providers
  end
end
