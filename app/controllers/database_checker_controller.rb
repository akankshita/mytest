class DatabaseCheckerController < ApplicationController
  def index
    @config_app = AppConfig.all
    @user = User.all
    @electricity_reading = ElectricityReading.all
    @gas_reading = GasReading.all
  end

end
