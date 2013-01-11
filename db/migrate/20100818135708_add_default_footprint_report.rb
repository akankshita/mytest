class AddDefaultFootprintReport < ActiveRecord::Migration
    def self.up
      deadline_date = Date.civil(2011, 7, 31)
      FootprintReport.create :deadline => deadline_date, :title => "Footprint Report Phase One", :more_info => "<Placeholder for more info>", :phase => 1 
  end

  def self.down
    
  end
end
