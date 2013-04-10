class CarbonDetailController < ApplicationController
  def index
  ############################################
  #Date filters
  
   #end date
   if(params[:selected_end_date] == nil || params[:selected_end_date] == '')
  	  #end_date = "2013-01-01"#Date.civil(3000,1,1).to_s(:db)
  	 # @current_selected_end_date = "31/12/2012"
  	  end_date =(Date.today>>1).strftime("%Y-%m-%d")#"2013-01-01"#Date.civil(3000,1,1).to_s(:db)
  	  @current_selected_end_date = Date.today.strftime("%d/%m/%Y")#"31/12/2012"  	 
   else
      @current_selected_end_date = FilterUtils.handle_textfield_memory(params[:selected_end_date])
      end_date = TimeUtils.parse_european_date(params[:selected_end_date]) + 1.day
   end

   #start date
  if(params[:selected_start_date] == nil || params[:selected_start_date] == '')
  	#start_date = "2012-01-01"#Date.civil(1000,1,1).to_s(:db)
  	#@current_selected_start_date = "01/01/2012"
  	#@con_fac_year = 2012
  	start_date = Time.now.year.to_s + "-01-01"#Date.civil(1000,1,1).to_s(:db)
	@current_selected_start_date = "01/01/"+Time.now.year.to_s
	@con_fac_year = Time.now.year
  else
    @current_selected_start_date = FilterUtils.handle_textfield_memory(params[:selected_start_date])
    start_date = TimeUtils.parse_european_date(params[:selected_start_date])
    #render :text => start_date.year.inspect and return false
    @con_fac_year = start_date.year
    
    result = Array.new
    errors = Array.new
    errors += FilterUtils.perform_start_end_date_validation(params)
    if errors.size > 0
        flash[:notice] = FilterUtils.format_errors(errors)
        return
    end
  end


 ecrate = ConversionFactor.find_by_year_and_source_type_id(@con_fac_year,2)
 if !ecrate.nil?
   econversionrate = ecrate.rate
 else
   econversionrate = 1
 end
 gcrate = ConversionFactor.find_by_year_and_source_type_id(@con_fac_year,1)
 if !gcrate.nil?
   gconversionrate = gcrate.rate
 else
   gconversionrate = 1
 end
 #render :text => crate.rate.inspect and return false
 calc_string = "sum((((extract(epoch from end_time)) - (extract(epoch from start_time))) / (extract(epoch from (interval '1 hour')))) * electricity_value )" 

####Comparison by day of week
	values = Array.new
	names  = Array.new
	
	select_string = " select #{calc_string} * #{econversionrate}   as value, extract(dow from start_time) as dow from electricity_readings  where start_time >= '#{start_date}' AND end_time <= '#{end_date}'  group by dow order by dow;"
  #render :text =>  select_string.inspect and return false
	
	result = ElectricityReading.find_by_sql(select_string)
	days = FilterUtils.get_days_of_week_hash
	 
	result.each do |k|
		values.push( k.value )
		day_value = k.dow.to_i
		names.push("'"+ days[ day_value ][0]+"'")
	end

  #this is used for making this controller testable through a cucumber feature
  @days_with_data = values.size

	@day_data = StringUtils.generate_json_array_without_timestamp(values, "data")
  #render :text =>   @day_data.inspect and return false
	@day_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")
	
	
####Comparison by Months	
	values= []
	names=[]
#render :text => calc_string.inspect and return false
	result = ElectricityReading.find_by_sql("select #{calc_string} * #{econversionrate} as value, extract(month from start_time) as month from electricity_readings where start_time >= '#{start_date}' AND end_time <= '#{end_date}'  group by month order by month;")
	months = FilterUtils.get_month_hash
	 
	result.each do |k|
		values.push( k.value)
		month_value = k.month.to_i-1 #db months start from 1 but filterUtils function starts from 0
		names.push("'"+ months[ month_value ][0]+"'")
	end

  #this is used for making this controller testable through a cucumber feature
  @months_with_data = values.size

	@month_data = StringUtils.generate_json_array_without_timestamp(values, "data")
	@month_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")

####by year 
	values = [] 
	names = []
	result=[]

	result = ElectricityReading.find_by_sql("select #{calc_string} * #{econversionrate} as value, extract(year from start_time) as year from electricity_readings where start_time >= '#{start_date}' AND end_time <= '#{end_date}'  group by year order by year;")	
	 
	result.each do |k|	
		values.push( k.value )		
		names.push( "'"+k.year+"'" )
	end
	
	@year_data = StringUtils.generate_json_array_without_timestamp(values, "data")
	@year_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")


####meters
	values = [] 
	names = []
	result=[]
	
	result = ElectricityReading.all(:select => "#{calc_string} * #{econversionrate} AS sum, node_entries.name AS name", :from => "electricity_readings, meters, node_entries", :conditions => "electricity_readings.meter_id = meters.id AND electricity_readings.meter_id = node_entries.node_id AND node_entries.node_type = 'Meter' AND start_time >= '#{start_date}' AND end_time <= '#{end_date}'", :group => "electricity_readings.meter_id, node_entries.name", :order => "meter_id")
	result.each do |k|
		values.push(k.sum)				
		names.push("'"+k.name+"'")
	end

	@meter_data = StringUtils.generate_json_array_without_timestamp(values, "data")
	@meter_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")
	
	
####meter groups
	meter_ids = Array.new
	group_ids = Array.new 
	values = [] 
	names = []
	result=[]
			
	group_ids = FilterUtils.get_meter_group_hash	
	group_ids.each do |group_key, group_value|

		meter_ids = []
		FilterUtils.get_meter_ids_from_meter_groups( [group_value], meter_ids, (SourceType.first(:conditions => "name = 'Electrical Readings'").name) )		
		
		if(meter_ids == [])
			meter_ids = "-1"
		else
			meter_ids =  meter_ids.join(",")
		end
		
		result = ElectricityReading.all(:select => "#{calc_string}", :conditions => "start_time >= '#{start_date}' AND end_time <= '#{end_date}' AND meter_id IN (" + meter_ids +")"   ) 
		if(result.first.sum != nil)
		   newval = (result.first.sum.to_f * econversionrate).to_s
		  # render :text => newval.inspect and return false
			values.push(newval)
			names.push("'"+group_key+"'")
		end
			
	end
	
  @meter_group_data = StringUtils.generate_json_array_without_timestamp(values, "data")
	@meter_group_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")		


####Location
	locations = Array.new
	descendants = Array.new
	values = [] 
	names = []
	result =[]
	
	locations = NodeEntry.all(:conditions => "node_type = 'Location'")
	
	locations.each do |l|
		
		descendants = l.descendants
		meter_ids=[]
			
		descendants.each do |d|		
				
			if d.node_type == "Meter"
				meter_ids.push(d.node_id)
			end
		end	
						
		result=[]
		
		if(meter_ids == [])
			meter_ids = "-1"
		else
			meter_ids =  meter_ids.join(",")
		end
		
		result = ElectricityReading.all(:select => "#{calc_string}", :conditions => "start_time >= '#{start_date}' AND end_time <= '#{end_date}' AND meter_id IN ("+meter_ids+")" )

		if(result.first.sum != nil)
		   newval = (result.first.sum.to_f * econversionrate).to_s
			values.push(newval)
			names.push("'"+l.name+"'")
		end
		
	end
	
  @location_data = StringUtils.generate_json_array_without_timestamp(values, "data")
	@location_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")		


####Region 
	#region is the same as location above only that more than one row may belong to a single region 	
	locations   = []
	descendants = []
	values = []
	names = []	
	region_ids = Array.new
	
	locations = Location.all()
	locations.each do |l|
		region_ids.push( l.region_id ) 
	end
	
	region_ids = region_ids.uniq;
	locations = []
	
	region_ids.each do |r|
		locations = Location.all(:conditions => ["region_id IN (?)",r])
		
		meter_ids = []
		locations.each do |l|
			descendants = l.node_entry.descendants			
			descendants.each do |d|						
				if d.node_type == "Meter"
					meter_ids.push(d.node_id)
				end
			end						
		end
						
		if(meter_ids == [])
			meter_ids = "-1"
		else
			meter_ids =  meter_ids.join(",")
		end				
						
		result = ElectricityReading.all(:select => "#{calc_string}", :conditions => "start_time >= '#{start_date}' AND end_time <= '#{end_date}' AND meter_id IN ("+meter_ids+")")

		if(result.first.sum != nil)
		    newval = (result.first.sum.to_f * econversionrate).to_s
		    values.push( newval)
			region_object = Region.all(:conditions => ["id = (?)",r])
			names.push("'"+region_object.first.name+"'")
		end
											
	end

	@region_data = StringUtils.generate_json_array_without_timestamp(values, "data")
	@region_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")		



####Countries  
	#there should only be a few countries so I cycle through all rather than the above 	
	locations   = []
	descendants = []
	values = []
	names = []	
	region_ids = []
	country_ids = Array.new
	
	countries = Country.all();
	countries.each do |c|		 
		locations = Location.all(:select => "locations.id", :from => "locations, regions, countries", :conditions => "locations.region_id = regions.id AND regions.country_id = countries.id AND countries.id = #{c.id}")
		
		if(locations != [])
		
			meter_ids = []
			locations.each do |p|
			
				descendants = p.node_entry.descendants			
				descendants.each do |q|						
					if q.node_type == "Meter"
						meter_ids.push(q.node_id)
					end
				end						
			end
							
			if(meter_ids == [])
				meter_ids = "-1"
			else
				meter_ids =  meter_ids.join(",")
			end							
							
			result = ElectricityReading.all(:select => "#{calc_string}", :conditions => "start_time >= '#{start_date}' AND end_time <= '#{end_date}' AND meter_id IN ("+meter_ids+")" )
	
			if(result.first.sum != nil)
			    newval = (result.first.sum.to_f * econversionrate).to_s
				values.push( newval)
				names.push("'"+c.name+"'")
			end			
		end
  end
		
	@country_data = StringUtils.generate_json_array_without_timestamp(values, "data")
	@country_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")		

  end

  def carbon_gas_detail

   #end date
   if(params[:selected_end_date] == nil || params[:selected_end_date] == '')
  	 # end_date = "2013-01-01"#Date.civil(3000,1,1).to_s(:db)
  	  #@current_selected_end_date = "31/12/2012"
  	  end_date =(Date.today>>1).strftime("%Y-%m-%d")#"2013-01-01"#Date.civil(3000,1,1).to_s(:db)
  	  @current_selected_end_date = Date.today.strftime("%d/%m/%Y")#"31/12/2012"
   else
      @current_selected_end_date = FilterUtils.handle_textfield_memory(params[:selected_end_date])
      end_date = TimeUtils.parse_european_date(params[:selected_end_date]) + 1.day
   end

   #start date
  if(params[:selected_start_date] == nil || params[:selected_start_date] == '')
  	#start_date = "2012-01-01"#Date.civil(1000,1,1).to_s(:db)
  #	@current_selected_start_date = "01/01/2012"
	start_date = Time.now.year.to_s + "-01-01"#Date.civil(1000,1,1).to_s(:db)
	@current_selected_start_date = "01/01/"+Time.now.year.to_s 
  	@con_fac_year = Time.now.year
  else
    @current_selected_start_date = FilterUtils.handle_textfield_memory(params[:selected_start_date])
    start_date = TimeUtils.parse_european_date(params[:selected_start_date])
    #render :text => start_date.year.inspect and return false
    @con_fac_year = start_date.year
    
    result = Array.new
    errors = Array.new
    errors += FilterUtils.perform_start_end_date_validation(params)
    if errors.size > 0
        flash[:notice] = FilterUtils.format_errors(errors)
        return
    end
  end


 ecrate = ConversionFactor.find_by_year_and_source_type_id(@con_fac_year,2)
 if !ecrate.nil?
   econversionrate = ecrate.rate
 else
   econversionrate = 1
 end
 gcrate = ConversionFactor.find_by_year_and_source_type_id(@con_fac_year,1)
 if !gcrate.nil?
   gconversionrate = gcrate.rate
 else
   gconversionrate = 1
 end


####Comparison by day of week
	values = Array.new
	names  = Array.new
	result = GasReading.find_by_sql("select sum(gas_value) * #{gconversionrate} as value, extract(dow from start_time) as dow from gas_readings where start_time >= '#{start_date}' AND end_time <= '#{end_date}'  group by dow order by dow;")
	#select_string = " select #{calc_string} as value, extract(dow from end_time) as dow from electricity_readings  where start_time >= '#{start_date}' AND end_time <= '#{end_date}'  group by dow order by dow;"
  #render :text =>  select_string.inspect and return false
	
	#result = ElectricityReading.find_by_sql(select_string)
	days = FilterUtils.get_days_of_week_hash
	 
	result.each do |k|
		values.push( k.value )
		day_value = k.dow.to_i
		names.push("'"+ days[ day_value ][0]+"'")
	end

  #this is used for making this controller testable through a cucumber feature
  @days_with_data = values.size

	@day_data = StringUtils.generate_json_array_without_timestamp(values, "data")
  
	@day_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")
#	render :text =>  @day_categories.inspect and return false

####Comparison by Months
    values = Array.new
    names = Array.new
#aka = "select sum(gas_value) as value, extract(month from start_time) as month from gas_readings where start_time >= '#{start_date}' AND end_time <= '#{end_date}'  group by month order by month;"
#render :text => aka.insert
    result = GasReading.find_by_sql("select sum(gas_value) * #{gconversionrate} as value, extract(month from start_time) as month from gas_readings where start_time >= '#{start_date}' AND end_time <= '#{end_date}'  group by month order by month;")
    months = FilterUtils.get_month_hash

    result.each do |k|
      values.push(k.value)
      month_value = k.month.to_i-1 #db months start from 1 but filterUtils function starts from 0
      names.push("'"+ months[month_value][0]+"'")
    end

    @months_with_data = values.size

    @month_data = StringUtils.generate_json_array_without_timestamp(values, "data")
    @month_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")

####by year 
    values = []
    names = []
    result=[]
#render :text => end_date.inspect and return false
    result = GasReading.find_by_sql("select sum(gas_value) * #{gconversionrate} as value, extract(year from start_time) as year from gas_readings where start_time >= '#{start_date}' AND end_time <= '#{end_date}'  group by year order by year;")

    result.each do |k|
      values.push(k.value)
      names.push("'"+k.year+"'")
    end

    @year_data = StringUtils.generate_json_array_without_timestamp(values, "data")
    #render :text => @year_data.inspect and return false
    @year_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")


####meters
    result = Array.new
    values = Array.new
    names = Array.new

    result = GasReading.all(:select => "sum(gas_value) * #{gconversionrate} AS sum, node_entries.name AS name", :from => "gas_readings, meters, node_entries", :conditions => "gas_readings.meter_id = meters.id AND gas_readings.meter_id = node_entries.node_id AND node_entries.node_type = 'Meter' AND start_time >= '#{start_date}' AND end_time <= '#{end_date}'", :group => "gas_readings.meter_id, node_entries.name", :order => "meter_id")
    result.each do |k|
      values.push(k.sum)
      names.push("'"+k.name+"'")
    end

    @meter_data = StringUtils.generate_json_array_without_timestamp(values, "data")
    @meter_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")


####meter groups
    meter_ids = Array.new
    group_ids = Array.new
    values = []
    names = []
    result=[]

    group_ids = FilterUtils.get_meter_group_hash
    group_ids.each do |group_key, group_value|

      meter_ids = []
      FilterUtils.get_meter_ids_from_meter_groups([group_value], meter_ids, (SourceType.first(:conditions => "name = 'Gas Readings'").name))

      if (meter_ids == [])
        meter_ids = "-1"
      else
        meter_ids = meter_ids.join(",")
      end

      result = GasReading.all(:select => "sum(gas_value)", :conditions => "start_time >= '#{start_date}' AND end_time <= '#{end_date}' AND meter_id IN (" + meter_ids +")")
      if (result.first.sum != nil)
		newval = (result.first.sum.to_f * gconversionrate).to_s
        values.push(newval)
        names.push("'"+group_key+"'")
      end

    end

    @meter_group_data = StringUtils.generate_json_array_without_timestamp(values, "data")
    @meter_group_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")


####Location
    locations = Array.new
    descendants = Array.new
    values = []
    names = []
    result =[]

    locations = NodeEntry.all(:conditions => "node_type = 'Location'")

    locations.each do |l|

      descendants = l.descendants
      meter_ids=[]

      descendants.each do |d|

        if d.node_type == "Meter"
          meter_ids.push(d.node_id)
        end
      end

      result=[]

      if (meter_ids == [])
        meter_ids = "-1"
      else
        meter_ids = meter_ids.join(",")
      end

      result = GasReading.all(:select => "sum(gas_value)", :conditions => "start_time >= '#{start_date}' AND end_time <= '#{end_date}' AND meter_id IN ("+meter_ids+")")

      if (result.first.sum != nil)
		newval = (result.first.sum.to_f * gconversionrate).to_s
        values.push(newval )
        names.push("'"+l.name+"'")
      end
    end

    @location_data = StringUtils.generate_json_array_without_timestamp(values, "data")
    @location_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")


####Region 
    #region is the same as location above only that more than one row may belong to a single region
    locations = []
    descendants = []
    values = []
    names = []
    region_ids = Array.new

    locations = Location.all()
    locations.each do |l|
      region_ids.push(l.region_id)
    end

    region_ids = region_ids.uniq;
    locations = []

    region_ids.each do |r|
      locations = Location.all(:conditions => ["region_id IN (?)", r])

      meter_ids = []
      locations.each do |l|
        descendants = l.node_entry.descendants
        descendants.each do |d|
          if d.node_type == "Meter"
            meter_ids.push(d.node_id)
          end
        end
      end

      if (meter_ids == [])
        meter_ids = "-1"
      else
        meter_ids = meter_ids.join(",")
      end

      result = GasReading.all(:select => "sum(gas_value)", :conditions => "start_time >= '#{start_date}' AND end_time <= '#{end_date}' AND meter_id IN ("+meter_ids+")")

      if (result.first.sum != nil)
		 newval = (result.first.sum.to_f * gconversionrate).to_s
        values.push(newval)
        region_object = Region.all(:conditions => ["id = (?)", r])
        names.push("'"+region_object.first.name+"'")
      end
    end

    @region_data = StringUtils.generate_json_array_without_timestamp(values, "data")
    @region_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")


####Countries  
    #there should only be a few countries so I cycle through all rather than the above
    locations = []
    descendants = []
    values = []
    names = []
    region_ids = []
    country_ids = Array.new

    countries = Country.all();
    countries.each do |c|
      locations = Location.all(:select => "locations.id", :from => "locations, regions, countries", :conditions => "locations.region_id = regions.id AND regions.country_id = countries.id AND countries.id = #{c.id}")

      if (locations != [])

        meter_ids = []
        locations.each do |p|

          descendants = p.node_entry.descendants
          descendants.each do |q|
            if q.node_type == "Meter"
              meter_ids.push(q.node_id)
            end
          end
        end

        if (meter_ids == [])
          meter_ids = "-1"
        else
          meter_ids = meter_ids.join(",")
        end

        result = GasReading.all(:select => "sum(gas_value)", :conditions => "start_time >= '#{start_date}' AND end_time <= '#{end_date}' AND meter_id IN ("+meter_ids+")")

        if (result.first.sum != nil)
		  newval = (result.first.sum.to_f * gconversionrate).to_s
          values.push(newval)
          names.push("'"+c.name+"'")
        end
      end
    end

    @country_data = StringUtils.generate_json_array_without_timestamp(values, "data")
    @country_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")



  end
  
  def carbon_mixed_detail
    
   #end date
   if(params[:selected_end_date] == nil || params[:selected_end_date] == '')
  	 # end_date = "2013-01-01"#Date.civil(3000,1,1).to_s(:db)
  	  #@current_selected_end_date = "31/12/2012"
  	  end_date =(Date.today>>1).strftime("%Y-%m-%d")#"2013-01-01"#Date.civil(3000,1,1).to_s(:db)
  	  @current_selected_end_date = Date.today.strftime("%d/%m/%Y")#"31/12/2012"  	  
   else
      @current_selected_end_date = FilterUtils.handle_textfield_memory(params[:selected_end_date])
      end_date = TimeUtils.parse_european_date(params[:selected_end_date]) + 1.day
   end

   #start date
  if(params[:selected_start_date] == nil || params[:selected_start_date] == '')
  	#start_date = "2012-01-01"#Date.civil(1000,1,1).to_s(:db)
  	#@current_selected_start_date = "01/01/2012"
	start_date = Time.now.year.to_s + "-01-01"#Date.civil(1000,1,1).to_s(:db)
	@current_selected_start_date = "01/01/"+Time.now.year.to_s   	
  	@con_fac_year = Time.now.year
  else
    @current_selected_start_date = FilterUtils.handle_textfield_memory(params[:selected_start_date])
    start_date = TimeUtils.parse_european_date(params[:selected_start_date])
    #render :text => start_date.year.inspect and return false
    @con_fac_year = start_date.year
    
    result = Array.new
    errors = Array.new
    errors += FilterUtils.perform_start_end_date_validation(params)
    if errors.size > 0
        flash[:notice] = FilterUtils.format_errors(errors)
        return
    end
  end


 ecrate = ConversionFactor.find_by_year_and_source_type_id(@con_fac_year,2)
 if !ecrate.nil?
   econversionrate = ecrate.rate
 else
   econversionrate = 1
 end
 gcrate = ConversionFactor.find_by_year_and_source_type_id(@con_fac_year,1)
 if !gcrate.nil?
   gconversionrate = gcrate.rate
 else
   gconversionrate = 1
 end

  # sql query to convert kW to kWhours, taking in to account the duration of power applied 
  #calc_string = "sum((((extract(epoch from end_time)) - (extract(epoch from start_time))) / (extract(epoch from (interval '1 hour')))) * electricity_value)"
  calc_string = "sum((((extract(epoch from end_time)) - (extract(epoch from start_time))) / (extract(epoch from (interval '1 hour')))) * electricity_value )" 

####Comparison by day of week
	values_ele = Array.new
	names  = Array.new
	
	select_string = " select #{calc_string} * #{econversionrate} as value, extract(dow from start_time) as dow from electricity_readings  where start_time >= '#{start_date}' AND end_time <= '#{end_date}'  group by dow order by dow;"
  #render :text =>  select_string.inspect and return false
	
	result = ElectricityReading.find_by_sql(select_string)
	days = FilterUtils.get_days_of_week_hash
	 
	result.each do |k|
		values_ele.push( k.value )
		day_value = k.dow.to_i
		names.push("'"+ days[ day_value ][0]+"'")
	end

  #this is used for making this controller testable through a cucumber feature
   @days_with_data = values_ele.size

	@day_data = StringUtils.generate_json_array_without_timestamp(values_ele, "data")
  #render :text =>   @day_data.inspect and return false
	@day_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")

 ####Comparison by day of week
	values_gas = Array.new
	names  = Array.new
	result = GasReading.find_by_sql("select sum(gas_value) * #{gconversionrate} as value, extract(dow from start_time) as dow from gas_readings where start_time >= '#{start_date}' AND end_time <= '#{end_date}'  group by dow order by dow;")
	#select_string = " select #{calc_string} as value, extract(dow from end_time) as dow from electricity_readings  where start_time >= '#{start_date}' AND end_time <= '#{end_date}'  group by dow order by dow;"
  #render :text =>  select_string.inspect and return false
	
	#result = ElectricityReading.find_by_sql(select_string)
	days = FilterUtils.get_days_of_week_hash
	 
	result.each do |k|
		values_gas.push( k.value )
		day_value = k.dow.to_i
		names.push("'"+ days[ day_value ][0]+"'")
	end

  #this is used for making this controller testable through a cucumber feature
  @days_with_data = values_gas.size
  
  @sum_day_data = Array.new
  values_ele.each_with_index do |val,i|
    @sum_day_data <<  (val.to_f+values_gas[i].to_f)
  end
  @day_data = StringUtils.generate_json_array_without_timestamp(@sum_day_data, "data")
 
####Comparison by Months	ele
	values_ele= []
	names=[]
#render :text => calc_string.inspect and return false
	result = ElectricityReading.find_by_sql("select #{calc_string} * #{econversionrate} as value, extract(month from start_time) as month from electricity_readings where start_time >= '#{start_date}' AND end_time <= '#{end_date}'  group by month order by month;")
	months = FilterUtils.get_month_hash
	 
	result.each do |k|
		values_ele.push( k.value)
		month_value = k.month.to_i-1 #db months start from 1 but filterUtils function starts from 0
		names.push("'"+ months[ month_value ][0]+"'")
	end

  #this is used for making this controller testable through a cucumber feature
  @months_with_data = values_ele.size

	#@month_data = StringUtils.generate_json_array_without_timestamp(values, "data")
	@month_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")

####Comparison by Months gas
    values_gas = Array.new
    names = Array.new

    result = GasReading.find_by_sql("select sum(gas_value) * #{gconversionrate} as value, extract(month from start_time) as month from gas_readings where start_time >= '#{start_date}' AND end_time <= '#{end_date}'  group by month order by month;")
    months = FilterUtils.get_month_hash

    result.each do |k|
      values_gas.push(k.value)
      month_value = k.month.to_i-1 #db months start from 1 but filterUtils function starts from 0
      names.push("'"+ months[month_value][0]+"'")
    end
#render :text => values_ele.inspect and return false
    @months_with_data = values_gas.size
    @sum_month_data = Array.new    
    values_ele.each_with_index do |val,i|
      @sum_month_data <<  (val.to_f+values_gas[i].to_f)
    end
    

    @month_data = StringUtils.generate_json_array_without_timestamp(@sum_month_data, "data")
    
    
	values_ele = [] 
	names = []
	result=[]

	result = ElectricityReading.find_by_sql("select #{calc_string} * #{econversionrate} as value, extract(year from start_time) as year from electricity_readings where start_time >= '#{start_date}' AND end_time <= '#{end_date}'  group by year order by year;")	
	 
	result.each do |k|	
		values_ele.push( k.value )		
		names.push( "'"+k.year+"'" )
	end
	
	#@year_data = StringUtils.generate_json_array_without_timestamp(values, "data")
	@year_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")    
####by year 
    values_gas = []
    names = []
    result=[]
#render :text => end_date.inspect and return false
    result = GasReading.find_by_sql("select sum(gas_value) * #{gconversionrate} as value, extract(year from start_time) as year from gas_readings where start_time >= '#{start_date}' AND end_time <= '#{end_date}'  group by year order by year;")

    result.each do |k|
      values_gas.push(k.value)
      names.push("'"+k.year+"'")
    end
    @sum_year_data = Array.new    
    values_ele.each_with_index do |val,i|
      @sum_year_data <<  (val.to_f+values_gas[i].to_f)
    end

    @year_data = StringUtils.generate_json_array_without_timestamp(@sum_year_data, "data")
    
####meters
	values_ele = [] 
	names = []
	result=[]
	
	result = ElectricityReading.all(:select => "#{calc_string} AS sum, node_entries.name AS name", :from => "electricity_readings, meters, node_entries", :conditions => "electricity_readings.meter_id = meters.id AND electricity_readings.meter_id = node_entries.node_id AND node_entries.node_type = 'Meter' AND start_time >= '#{start_date}' AND end_time <= '#{end_date}'", :group => "electricity_readings.meter_id, node_entries.name", :order => "meter_id")
	result.each do |k|
		enewval = (k.sum.to_f * econversionrate).to_s
		values_ele.push(enewval)				
		names.push("'"+k.name+"'")
	end

	#@meter_data = StringUtils.generate_json_array_without_timestamp(values, "data")
	@meter_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")
	
    result = Array.new
    values_gas = Array.new
    names = Array.new

    result = GasReading.all(:select => "sum(gas_value) AS sum, node_entries.name AS name", :from => "gas_readings, meters, node_entries", :conditions => "gas_readings.meter_id = meters.id AND gas_readings.meter_id = node_entries.node_id AND node_entries.node_type = 'Meter' AND start_time >= '#{start_date}' AND end_time <= '#{end_date}'", :group => "gas_readings.meter_id, node_entries.name", :order => "meter_id")
    result.each do |k|
	  gnewval = (k.sum.to_f * gconversionrate).to_s
      values_gas.push(gnewval)
      names.push("'"+k.name+"'")
    end
    @sum_meter_data = Array.new    
    values_ele.each_with_index do |val,i|
      @sum_meter_data <<  (val.to_f+values_gas[i].to_f)
    end
    @meter_data = StringUtils.generate_json_array_without_timestamp(@sum_meter_data, "data")

####meter groups
	meter_ids = Array.new
	group_ids = Array.new 
	values_ele = [] 
	names = []
	result=[]
			
	group_ids = FilterUtils.get_meter_group_hash	
	group_ids.each do |group_key, group_value|

		meter_ids = []
		FilterUtils.get_meter_ids_from_meter_groups( [group_value], meter_ids, (SourceType.first(:conditions => "name = 'Electrical Readings'").name) )		
		
		if(meter_ids == [])
			meter_ids = "-1"
		else
			meter_ids =  meter_ids.join(",")
		end
		
		result = ElectricityReading.all(:select => "#{calc_string}", :conditions => "start_time >= '#{start_date}' AND end_time <= '#{end_date}' AND meter_id IN (" + meter_ids +")"   ) 
		if(result.first.sum != nil)
		    enewval = (result.first.sum.to_f * econversionrate).to_s
			values_ele.push( enewval)
			names.push("'"+group_key+"'")
		end
			
	end
	
  #@meter_group_data = StringUtils.generate_json_array_without_timestamp(values, "data")
	@meter_group_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")

####meter groups
    meter_ids = Array.new
    group_ids = Array.new
    values_gas = []
    names = []
    result=[]

    group_ids = FilterUtils.get_meter_group_hash
    group_ids.each do |group_key, group_value|

      meter_ids = []
      FilterUtils.get_meter_ids_from_meter_groups([group_value], meter_ids, (SourceType.first(:conditions => "name = 'Gas Readings'").name))

      if (meter_ids == [])
        meter_ids = "-1"
      else
        meter_ids = meter_ids.join(",")
      end

      result = GasReading.all(:select => "sum(gas_value)", :conditions => "start_time >= '#{start_date}' AND end_time <= '#{end_date}' AND meter_id IN (" + meter_ids +")")
      if (result.first.sum != nil)
		gnewval = (result.first.sum.to_f * gconversionrate).to_s
        values_gas.push(gnewval)
        names.push("'"+group_key+"'")
      end

    end

    @sum_meter_group_data = Array.new    
    values_ele.each_with_index do |val,i|
      @sum_meter_group_data <<  (val.to_f+values_gas[i].to_f)
    end

    @meter_group_data = StringUtils.generate_json_array_without_timestamp(@sum_meter_group_data, "data")
   # @meter_group_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")

####Location
	locations = Array.new
	descendants = Array.new
	values_ele = [] 
	names = []
	result =[]
	
	locations = NodeEntry.all(:conditions => "node_type = 'Location'")
	
	locations.each do |l|
		
		descendants = l.descendants
		meter_ids=[]
			
		descendants.each do |d|		
				
			if d.node_type == "Meter"
				meter_ids.push(d.node_id)
			end
		end	
						
		result=[]
		
		if(meter_ids == [])
			meter_ids = "-1"
		else
			meter_ids =  meter_ids.join(",")
		end
		
		result = ElectricityReading.all(:select => "#{calc_string}", :conditions => "start_time >= '#{start_date}' AND end_time <= '#{end_date}' AND meter_id IN ("+meter_ids+")" )

		if(result.first.sum != nil)
		   enewval = (result.first.sum.to_f * econversionrate).to_s
			values_ele.push(enewval)
			names.push("'"+l.name+"'")
		end
		
	end
	
  #@location_data = StringUtils.generate_json_array_without_timestamp(values, "data")
	@location_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")    
   
####Location
    locations = Array.new
    descendants = Array.new
    values_gas = []
    names = []
    result =[]

    locations = NodeEntry.all(:conditions => "node_type = 'Location'")

    locations.each do |l|

      descendants = l.descendants
      meter_ids=[]

      descendants.each do |d|

        if d.node_type == "Meter"
          meter_ids.push(d.node_id)
        end
      end

      result=[]

      if (meter_ids == [])
        meter_ids = "-1"
      else
        meter_ids = meter_ids.join(",")
      end

      result = GasReading.all(:select => "sum(gas_value)", :conditions => "start_time >= '#{start_date}' AND end_time <= '#{end_date}' AND meter_id IN ("+meter_ids+")")

      if (result.first.sum != nil)
		gnewval = (result.first.sum.to_f * gconversionrate).to_s
        values_gas.push(gnewval)
        names.push("'"+l.name+"'")
      end
    end

    @sum_location_data = Array.new    
    values_ele.each_with_index do |val,i|
      @sum_location_data <<  (val.to_f+values_gas[i].to_f)
    end

    @location_data = StringUtils.generate_json_array_without_timestamp(@sum_location_data, "data")
   # @location_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")


####Region 
	#region is the same as location above only that more than one row may belong to a single region 	
	locations   = []
	descendants = []
	values_ele = []
	names = []	
	region_ids = Array.new
	
	locations = Location.all()
	locations.each do |l|
		region_ids.push( l.region_id ) 
	end
	
	region_ids = region_ids.uniq;
	locations = []
	
	region_ids.each do |r|
		locations = Location.all(:conditions => ["region_id IN (?)",r])
		
		meter_ids = []
		locations.each do |l|
			descendants = l.node_entry.descendants			
			descendants.each do |d|						
				if d.node_type == "Meter"
					meter_ids.push(d.node_id)
				end
			end						
		end
						
		if(meter_ids == [])
			meter_ids = "-1"
		else
			meter_ids =  meter_ids.join(",")
		end				
						
		result = ElectricityReading.all(:select => "#{calc_string}", :conditions => "start_time >= '#{start_date}' AND end_time <= '#{end_date}' AND meter_id IN ("+meter_ids+")")

		if(result.first.sum != nil)
		    enewval = (result.first.sum.to_f * econversionrate).to_s
		    values_ele.push(enewval)
			region_object = Region.all(:conditions => ["id = (?)",r])
			names.push("'"+region_object.first.name+"'")
		end
											
	end

	@region_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")		

####Region 
    #region is the same as location above only that more than one row may belong to a single region
    locations = []
    descendants = []
    values_gas = []
    names = []
    region_ids = Array.new

    locations = Location.all()
    locations.each do |l|
      region_ids.push(l.region_id)
    end

    region_ids = region_ids.uniq;
    locations = []

    region_ids.each do |r|
      locations = Location.all(:conditions => ["region_id IN (?)", r])

      meter_ids = []
      locations.each do |l|
        descendants = l.node_entry.descendants
        descendants.each do |d|
          if d.node_type == "Meter"
            meter_ids.push(d.node_id)
          end
        end
      end

      if (meter_ids == [])
        meter_ids = "-1"
      else
        meter_ids = meter_ids.join(",")
      end

      result = GasReading.all(:select => "sum(gas_value)", :conditions => "start_time >= '#{start_date}' AND end_time <= '#{end_date}' AND meter_id IN ("+meter_ids+")")

      if (result.first.sum != nil)
		gnewval = (result.first.sum.to_f * gconversionrate).to_s
        values_gas.push(gnewval)
        region_object = Region.all(:conditions => ["id = (?)", r])
        names.push("'"+region_object.first.name+"'")
      end
    end

    @sum_region_data = Array.new    
    values_ele.each_with_index do |val,i|
      @sum_region_data <<  (val.to_f+values_gas[i].to_f)
    end

    @region_data = StringUtils.generate_json_array_without_timestamp(@sum_region_data, "data")


####Countries  
	#there should only be a few countries so I cycle through all rather than the above 	
	locations   = []
	descendants = []
	values_ele = []
	names = []	
	region_ids = []
	country_ids = Array.new
	
	countries = Country.all();
	countries.each do |c|		 
		locations = Location.all(:select => "locations.id", :from => "locations, regions, countries", :conditions => "locations.region_id = regions.id AND regions.country_id = countries.id AND countries.id = #{c.id}")
		
		if(locations != [])
		
			meter_ids = []
			locations.each do |p|
			
				descendants = p.node_entry.descendants			
				descendants.each do |q|						
					if q.node_type == "Meter"
						meter_ids.push(q.node_id)
					end
				end						
			end
							
			if(meter_ids == [])
				meter_ids = "-1"
			else
				meter_ids =  meter_ids.join(",")
			end							
							
			result = ElectricityReading.all(:select => "#{calc_string}", :conditions => "start_time >= '#{start_date}' AND end_time <= '#{end_date}' AND meter_id IN ("+meter_ids+")" )
	
			if(result.first.sum != nil)
			   enewval = (result.first.sum.to_f * econversionrate).to_s
				values_ele.push(enewval)
				names.push("'"+c.name+"'")
			end			
		end
  end
		
	@country_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")   


####Countries  
    #there should only be a few countries so I cycle through all rather than the above
    locations = []
    descendants = []
    values_gas = []
    names = []
    region_ids = []
    country_ids = Array.new

    countries = Country.all();
    countries.each do |c|
      locations = Location.all(:select => "locations.id", :from => "locations, regions, countries", :conditions => "locations.region_id = regions.id AND regions.country_id = countries.id AND countries.id = #{c.id}")

      if (locations != [])

        meter_ids = []
        locations.each do |p|

          descendants = p.node_entry.descendants
          descendants.each do |q|
            if q.node_type == "Meter"
              meter_ids.push(q.node_id)
            end
          end
        end

        if (meter_ids == [])
          meter_ids = "-1"
        else
          meter_ids = meter_ids.join(",")
        end

        result = GasReading.all(:select => "sum(gas_value)", :conditions => "start_time >= '#{start_date}' AND end_time <= '#{end_date}' AND meter_id IN ("+meter_ids+")")

        if (result.first.sum != nil)
		  gnewval = (result.first.sum.to_f * gconversionrate).to_s
          values_gas.push(gnewval)
          names.push("'"+c.name+"'")
        end
      end
    end


    @sum_country_data = Array.new    
    values_ele.each_with_index do |val,i|
      @sum_country_data <<  (val.to_f+values_gas[i].to_f)
    end

    @country_data = StringUtils.generate_json_array_without_timestamp(@sum_country_data, "data")
    
    
  end
    

end
