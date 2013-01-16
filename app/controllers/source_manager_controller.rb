class SourceManagerController < ApplicationController
  def index
    @location_node = NodeEntry.new
    @location = Location.new
    @location_node.node = @location
    
    @all_sources_types = SourceType.all
    
    @init_data = String.new
    last = Location.last
    Location.find_each do |location|
      if (location != last)
        @init_data += location.node_entry.to_custom_json_format + ','
      end
    end
    
    if(last != nil)
      @init_data += last.node_entry.to_custom_json_format
    end
    @init_data = CGI.unescape(@init_data)
    
    
    ##pre-load each country's regions into javascript function for dynamic switching of region dropdown   
    countries = Country.all()
    string = ""
        
    countries.each do |c|
    	 string += "case '#{c.id}':  section.innerHTML = \"<select id='location' name='location[region_id]'> "
		 
		 regions = Region.all(:conditions => "country_id = #{c.id}", :order => "name") 
		 regions.each do |r|
		 	string += " <option value='#{r.id}'>#{r.name}</option> "
		 end	  
    
    	 string += " </select>\" ; break; "
    end       
    @region_switch_statment = string
    
  end
      	  
end
