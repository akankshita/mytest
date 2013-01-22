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
  
  def edit_node
	@id = params["id"]
	#	render :text => @id.inspect and return false
	@all_sources_types = SourceType.all
	@all_node_detail = NodeEntry.find(@id)
	if @all_node_detail.node_type == "Location"
	  @location_info = Location.find(@all_node_detail.node_id)
	  @selected_region_id = @location_info.region_id
	  @cdetail = Region.find(@selected_region_id)
	  @selected_country_id = @cdetail.country_id
	  countries = Country.all()
	  string = ""
	  regionss = Region.all(:conditions => "country_id = #{@selected_country_id}", :order => "name")     
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
    if  @all_node_detail.node_type == "Meter"
	  @meter_detail = Meter.find(@all_node_detail.node_id)
    end


	render :partial => 'edit_node', :locals => {:all_node_detail => @all_node_detail,:region_switch_statment => @region_switch_statment,:regionss => regionss,:selected_region_id => @selected_region_id,:selected_country_id => @selected_country_id,:meter_detail => @meter_detail}
  end
  
  def update_node
	#render :text => params.inspect and return false
	@node_type = params["node_type"]
	@node_id = params["node_id"]
	@node_node_id = params["node_node_id"]
	if @node_type == "Location"
	  NodeEntry.update_all({:name => params["meter_name"]},['id = ?', @node_id])
	  Location.update_all({:region_id => params["region_id"][0]},['id = ?', @node_node_id])
	  flash[:notice] = 'Location was successfully updated.'
	end
	if @node_type == "MeterGroup"
	  NodeEntry.update_all({:name => params["meter_name"]},['id = ?', @node_id])
	  flash[:notice] = 'MeterGroup was successfully updated.'
	end
	if @node_type == "Meter"
	  NodeEntry.update_all({:name => params["meter_name"]},['id = ?', @node_id])
	  Meter.update_all({:meter_identifier => params["meter_meter_identifier"],:source_type_id => params["meter"]["source_type"]},['id = ?', @node_node_id])
	  flash[:notice] = 'Meter was successfully updated.'
	  
	end
	redirect_to :controller => 'source_manager', :action => 'index'
	#render :text => params.inspect and return false
  end
      	  
end
