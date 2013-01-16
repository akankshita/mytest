class AddDisplayNameForGasDetail < ActiveRecord::Migration
  def self.up
    ControllerDisplayName.create(:controller_name => GasDetailController.controller_name, :display_name => "Gas Comparisons")
  end

  def self.down
    ControllerDisplayName.delete_all(:controller_name => GasDetailController.controller_name)
  end
end
