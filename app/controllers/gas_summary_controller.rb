class GasSummaryController < ApplicationController
  
  #BoD DEBT removed minute handling code to simplify db query, when we have time (no pun) put this back in
  
  def index
    @current_selected_meter_group = FilterUtils.handle_selection_memory(params[:selected_meter_group])
    @current_selected_meter = FilterUtils.handle_selection_memory(params[:selected_meter])
    @current_selected_year = FilterUtils.handle_selection_memory(params[:selected_year])
    @current_selected_month = FilterUtils.handle_selection_memory(params[:selected_month])
    @current_selected_day_of_month = FilterUtils.handle_selection_memory(params[:selected_day_of_month])
    @current_selected_day_of_week = FilterUtils.handle_selection_memory(params[:selected_day_of_week])
    @current_selected_country = FilterUtils.handle_selection_memory(params[:selected_country])
    @current_selected_region = FilterUtils.handle_selection_memory(params[:selected_region])
    @current_selected_location = FilterUtils.handle_selection_memory(params[:selected_location])

    @current_selected_start_date = FilterUtils.handle_textfield_memory(params[:selected_start_date])
    @current_selected_end_date = FilterUtils.handle_textfield_memory(params[:selected_end_date])

    @current_selected_start_time_hour = FilterUtils.handle_textfield_memory(params[:selected_start_time_hour])
    #@current_selected_start_time_minute = FilterUtils.handle_textfield_memory(params[:selected_start_time_minute])
    @current_selected_start_time_am_pm = FilterUtils.handle_selection_memory(params[:selected_start_time_am_pm])
    
    @current_selected_end_time_hour = FilterUtils.handle_textfield_memory(params[:selected_end_time_hour])
    #@current_selected_end_time_minute = FilterUtils.handle_textfield_memory(params[:selected_end_time_minute])
    @current_selected_end_time_am_pm = FilterUtils.handle_selection_memory(params[:selected_end_time_am_pm])

	  @all_meter_groups = FilterUtils.get_meter_group_hash_by_source_type("Gas Readings")
    @all_meters = FilterUtils.get_meter_hash(SourceType.first(:conditions => "name = 'Gas Readings'"))
    @all_years = FilterUtils.get_year_hash
    @all_months = FilterUtils.get_month_hash
    @all_days_of_month = FilterUtils.get_days_of_month_hash
    @all_days_of_week = FilterUtils.get_days_of_week_hash
    @all_countries = FilterUtils.get_countries_hash
    @all_regions = FilterUtils.get_regions_hash
    @all_locations = FilterUtils.get_locations_hash




	  #time resolution code
	  if(params[:current_res] == nil)
	  	@current_res = "1"
	  else
	  	@current_res = params[:current_res]
	  end

      readings = Array.new      
      errors_list = Array.new
      
      #validations
      errors_list = FilterUtils.perform_filter_validation(params)
      flash_notice = FilterUtils.format_errors(errors_list)
      
      flash[:notice] = flash_notice
    
      if (errors_list.size == 0)
        meter_ids_children = Array.new
        FilterUtils.get_meter_ids_from_meters @current_selected_meter, meter_ids_children, "Gas Readings"
        
        meter_groups_children = Array.new         
        FilterUtils.get_meter_ids_from_meter_groups @current_selected_meter_group, meter_groups_children, "Gas Readings"
        
        start_date = end_date = start_time = end_time = nil
        start_date = TimeUtils.parse_european_date(@current_selected_start_date)
        end_date = TimeUtils.parse_european_date(@current_selected_end_date)
        
        #BoD DEBT replace 0 with @current_selected_start_time_minute
        start_time = TimeUtils.create_time_object(@current_selected_start_time_hour, 0, @current_selected_start_time_am_pm)
        end_time = TimeUtils.create_time_object(@current_selected_end_time_hour, 0, @current_selected_end_time_am_pm)
        
        readings = FilterUtils.get_readings_with_filters_applied GasReading, meter_ids_children, meter_groups_children, "gas", "gas_value", "end_time", @current_selected_year, @current_selected_month, @current_selected_day_of_month, @current_selected_day_of_week, start_date, end_date, start_time, end_time, @current_selected_country, @current_selected_region, @current_selected_location, @current_res
      end
    
    @data_count = readings.size

    #thin out data if necessary 
	  readings = FilterUtils.simple_resample(readings, graph_max_points) if @data_count > graph_max_points

    @max_min = Array.new
    @max_min[0] = @max_min[1] = 0            
    
    @data = StringUtils.generate_json_array(readings, "data", @current_res, @max_min)  

    @selected_filters = FilterUtils.filter_string_for_display(params)

    
    ####build javascript code to make filters dynamic####
    #meter groups and meters  
	meter_names = Array.new
	meter_values = Array.new
	index_array = Array.new
	all_meter_names = Array.new
	all_meter_values = Array.new 
	index_array.push(0)

	group_ids = FilterUtils.get_meter_group_hash_by_source_type("Gas Readings")	
	group_ids.each do |group_key, group_value|
		meter_ids = []
		FilterUtils.get_meter_ids_from_meter_groups( [group_value], meter_ids, (SourceType.first(:conditions => "name = 'Gas Readings'").name) )		

		index_array.push( index_array.last + meter_ids.size )
		
		meters = Meter.all(:conditions => ["id IN (?)",meter_ids])
		meters.each do |m|
			meter_names.push(m.node_entry.name)
			meter_values.push(m.id)
		end	
	end
		
	jstring  = "var numberOfGroups = " + group_ids.size.to_s + ";   "
	jstring += "var meter_names = new Array('"
	jstring += meter_names.join("','")  if(meter_names.size > 0 )
	jstring += "');   "
	jstring += "var meter_values = new Array('"
	jstring += meter_values.join("','") if(meter_values.size > 0)
	jstring += "');   "
	jstring += "var meter_index = new Array('"
	jstring += index_array.join("','") if(index_array.size > 0)
	jstring += "');   "
	
	all_meters = FilterUtils.get_meter_hash( SourceType.first(:conditions => "name = 'Gas Readings'") )	
	jstring += "var all_meter_names = new Array('"
	jstring += all_meters.keys.join("','") if(all_meters.size >0)
	jstring += "');   "		
	jstring += "var all_meter_values = new Array('"
	jstring += all_meters.values.join("','") if(all_meters.size >0)
	jstring += "');   "
	jstring += "var totalNumberOfMeters = "
	if(all_meters.size > 0)
		jstring += all_meters.size.to_s
	else
		jstring += "0"
	end
	jstring += ";    "
		        
	@reloadMeterSelectionData = jstring
	
	
	###countries and regions
	region_names = Array.new
	region_values = Array.new
	index_array = Array.new
	index_array.push(0) 	        
	jstring = ""
		
	countries = Country.all(:order => "name")
	countries.each do |c|
		regions = c.regions.all(:order => "name")
		
		index_array.push( index_array.last + regions.size )
		
		regions.each do |r|
			region_names.push( r.name )
			region_values.push( r.id )
		end	
	end
	
	jstring += "var numberOfCountries = " + Country.all.size.to_s + ";   "
	jstring += "var region_names = new Array('"
	jstring += region_names.join("','") if (region_names.size > 0)
	jstring += "');   "
	jstring += "var region_values = new Array('"
	jstring += region_values.join("','") if (region_values.size > 0)
	jstring += "');   "
	jstring += "var index_array = new Array('"
	jstring += index_array.join("','") if (index_array.size > 0)
	jstring += "');   "

	@reloadRegionSelectionData = jstring		


    ###locations
    location_names = Array.new
    location_values = Array.new 
	region_indexed_locations = Array.new	
    jstring = ""       
    
    locations = Location.all(:order => "id")
    locations.each do |l|
    	location_names.push( l.node_entry.name )
    	location_values.push( l.node_entry.node_id ) 
    	region_indexed_locations.push( l.region.id )   
    end
    
    jstring += "var numberOfLocations = " + Location.all.size.to_s + ";    "
	jstring += "var location_names = new Array('"
	jstring += location_names.join("','") if (location_names.size > 0)
	jstring += "');    "
	jstring += "var location_values = new Array('"
	jstring += location_values.join("','") if (location_values.size > 0)
	jstring += "');    "
	jstring += "var region_names = new Array('"
	jstring += region_names.join("','") if (region_names.size > 0)
	jstring += "');   "
	jstring += "var region_values = new Array('"
	jstring += region_values.join("','") if (region_values.size > 0)
	jstring += "');   "
	jstring += "var region_indexed_locations = new Array('"
	jstring += region_indexed_locations.join("','") if (region_indexed_locations.size > 0)
	jstring += "');    "

	@reloadLocationSelectionData = jstring 
    
  end
end
