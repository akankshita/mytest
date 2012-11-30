class CreateSignificantGroupUndertakingsTasks < ActiveRecord::Migration
  def self.up
    create_table :significant_group_undertakings_tasks do |t|
      t.references :annual_report
      t.integer :status
      t.string :more_info

      t.timestamps
    end
    
    annual_report = AnnualReport.first(:conditions => {:phase => 1})
    SignificantGroupUndertakingsTask.create :annual_report_id => annual_report.id, :more_info => "This section deals with reporting for any significant group undertakings for which you are the primary member.  A significant group undertaking is a collection of subsidaries in which any individual subsidary would qualify for the scheme in its own right", :status => 0  
  end

  def self.down
    drop_table :significant_group_undertakings_tasks
  end
end
