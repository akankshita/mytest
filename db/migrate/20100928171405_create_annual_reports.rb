class CreateAnnualReports < ActiveRecord::Migration
  def self.up
    create_table :annual_reports do |t|
      t.date :deadline
      t.string :title
      t.string :more_info
      t.integer :phase
      
      t.timestamps
    end
    
    deadline_date = Date.civil(2011, 7, 31)
    AnnualReport.create :deadline => deadline_date, :title => "Annual Report Phase One", :more_info => "<Placeholder for more info>", :phase => 1
    
  end

  def self.down
    drop_table :annual_reports
  end
end
