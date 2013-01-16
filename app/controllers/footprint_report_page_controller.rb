class FootprintReportPageController < ApplicationController

  def index    
    #DEBT -- BoD/FL needs to be updated to handle multiple phases in the future 
    @footprint_report = FootprintReport.first(:conditions => {:phase => 1}) 
    
  end
  
end
