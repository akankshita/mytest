class AnnualReportsController < ApplicationController
  # GET /annual_reports
  def index
    
    #DEBT -- BoD/FL needs to be updated to handle multiple phases in the future 
    @annual_report = AnnualReport.first(:conditions => {:phase => 1}) 
	@footprint_report = FootprintReport.first(:conditions => {:phase => 1}) #needed for common tasks 
  end
end
