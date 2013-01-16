class FixReportOtherFuelsControllerTypo < ActiveRecord::Migration
  def self.up
    typo = ControllerDisplayName.first(:conditions => "display_name = 'Report non-core fuelsa'")
    typo.display_name = "Report non-core fuels" unless typo.nil?
    typo.save unless typo.nil?
    
  end

  def self.down
  end
end
