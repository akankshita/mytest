class FilterUtils

  def FilterUtils.handle_textfield_memory select_name
   return_string = String.new

   if(select_name != nil) 
     return_string = select_name
   else
     return_string = nil
   end

   return_string
  end

  def FilterUtils.handle_selection_memory select_name, value_is_string = false
  return_array = Array.new
   if(select_name != nil)
      select_name[:value].each {|current|
        if(!value_is_string)             
          	return_array.push(current.to_i)          	
        else     
        	return_array.push(current)        	
        end
      }
   else
     return_array =  nil
   end
   return_array
  end

  def FilterUtils.get_year_hash
   #will return a hash with every year since 2005
   return_hash = Hash.new
   time = Time.now
   last_year = time.year

   while(last_year != 2004)
     return_hash[last_year.to_s] = last_year
     last_year -= 1
   end

   return_hash
  end

  def FilterUtils.get_meter_hash meter_source_type
   return_hash = Hash.new
   Meter.return_all_meters(meter_source_type).each {|meter|
     return_hash["#{meter.node_entry.name}"] = meter.id
   }
   return_hash
  end

  def FilterUtils.get_month_hash
     [["January", 1],["February", 2],["March", 3],["April", 4],["May", 5],["June", 6],["July", 7],["August", 8],["September", 9],["October", 10],["November", 11],["December", 12]]
  end
  
  def FilterUtils.get_month_array
     [["Jan"],["Feb"],["Mar"],["Apr"],["May"],["Jun"],["Jul"],["Aug"],["Sep"],["Oct"],["Nov"],["Dec"]]
  end

  def FilterUtils.get_days_of_month_hash
   return_array = Array.new
   current_day = 1

   while(current_day <= 31)
     current_array = Array.new
     current_array.push(current_day.to_s)
     current_array.push(current_day)
     current_day += 1
     return_array.push(current_array)
   end
   return_array
  end

  def FilterUtils.get_days_of_week_hash
   [["Sunday", 0],["Monday", 1],["Tuesday", 2],["Wednesday", 3],["Thursday", 4],["Friday", 5],["Saturday", 6]]
  end
  
  def FilterUtils.get_abv_days_of_week_hash
    [["Sun", 0],["Mon", 1],["Tues", 2],["Wed", 3],["Thur", 4],["Fri", 5],["Sat", 6]]
   end

  def FilterUtils.get_countries_hash
   return_hash = Hash.new
    Country.all(:order => "name desc").each {|element|
        if(element.name != nil) 
          return_hash["#{element.name}"] = element.id
        end
    }
   return_hash
  end

  def FilterUtils.get_regions_hash
    return_hash = Hash.new
     Region.all(:order => "name desc").each {|element|
         if(element.name != nil) 
           return_hash["#{element.name}"] = element.id
         end
     }
    return_hash
  end

  def FilterUtils.get_locations_hash
    return_hash = Hash.new
     NodeEntry.all(:conditions => "node_type = 'Location'", :order => "name desc").each {|element|
         if(element.name != nil && element.node != nil) 
           return_hash["#{element.name}"] = element.node_id
         end
     }
    return_hash
  end

  def FilterUtils.get_meter_group_hash
      return_hash = Hash.new
       NodeEntry.all(:conditions => "node_type = 'MeterGroup'", :order => "name desc").each {|element|
           if(element.name != nil && element.node != nil) 
             return_hash["#{element.name}"] = element.node.id
           end
       }
      return_hash
  end
  
  def FilterUtils.get_meter_group_hash_by_source_type source_type_string
  	 return_hash = Hash.new
  	 meter_ids = Array.new 
  	 
  	 NodeEntry.all(:conditions => "node_type = 'MeterGroup'", :order => "name desc").each {|element|

	 	if(element.name != nil && element.node != nil)
	 		meter_ids = []
			get_meter_ids_from_meter_groups( [element.node_id], meter_ids, source_type_string )
						
      		if(meter_ids.size > 0)
            	return_hash["#{element.name}"] = element.node.id
            end
        end
     }
     return_hash
  end
  
  def FilterUtils.get_meter_ids_from_meters selected_meters, meter_ids, source_type_string
    selected_meters.each {|meter_id|
      meter_ids.push(meter_id)
      meter = Meter.find(meter_id)
      meter.node_entry.descendants.each{|child_node_entry|
        if(child_node_entry.node_type == "Meter" && child_node_entry.node.source_type.name == source_type_string)
          meter_ids.push(child_node_entry.node.id)
        end
      } unless meter.node_entry == nil && meter.node_entry.descendants == nil
    } unless selected_meters == nil 
  end
  
  def FilterUtils.get_meter_ids_from_meter_groups selected_meter_groups, meter_ids, source_type_string 
    selected_meter_groups.each {|meter_group_id|
      meter_group = MeterGroup.find(meter_group_id)
      meter_group.node_entry.descendants.each{|child_node_entry|
        if(child_node_entry.node_type == "Meter" && child_node_entry.node.source_type.name == source_type_string)
          meter_ids.push(child_node_entry.node.id)          
        end
      } unless meter_group.node_entry == nil && meter_group.node_entry.descendants == nil
    } unless selected_meter_groups == nil            
  end
  
  def FilterUtils.anything_selected? array
     (array != nil && array.size > 0 )
  end
  
  def FilterUtils.get_readings_with_filters_applied reading_class, meter_ids, meter_groups, edges_label, value_col_name, timestamp_col_name, years, months, days_of_month, days_of_week, start_date, end_date, start_time, end_time, countries, regions, locations, current_res  
    readings = Array.new
    all_conditions = Array.new
    
    meter_ids = StringUtils.db_friendly_string_from_array meter_ids
    
    all_conditions += ["meter_id IN (#{meter_ids})"] unless meter_ids.nil? || meter_ids.size <= 0
    
    meter_groups = StringUtils.db_friendly_string_from_array meter_groups
    
    all_conditions += ["meter_id IN (#{meter_groups})"] unless meter_groups.nil? || meter_groups.size <= 0
    
    years = StringUtils.db_friendly_string_from_array years
    
    all_conditions += ["EXTRACT(YEAR from #{timestamp_col_name}) IN (#{years})"] unless years.nil? 
    
    months = StringUtils.db_friendly_string_from_array months
    
    all_conditions += ["EXTRACT(MONTH from #{timestamp_col_name}) IN (#{months})"] unless months.nil? 
    
    days_of_month = StringUtils.db_friendly_string_from_array days_of_month
    
    all_conditions += ["EXTRACT(DAY from #{timestamp_col_name}) IN (#{days_of_month})"] unless days_of_month.nil?
    
    days_of_week = StringUtils.db_friendly_string_from_array days_of_week
    
    all_conditions += ["EXTRACT(DOW from #{timestamp_col_name}) IN (#{days_of_week})"] unless days_of_week.nil?


   all_conditions += ["#{timestamp_col_name} >= '#{start_date.to_time.to_s(:db)}'"] unless start_date.nil? 
   all_conditions += ["#{timestamp_col_name} < '#{((end_date + 1).to_time - 1).to_s(:db)}'"] unless end_date.nil?


    hours = StringUtils.db_friendly_string_from_array(TimeUtils.get_hours(start_time, end_time)) unless start_time.nil? || end_time.nil?
    
    all_conditions += ["EXTRACT(HOUR from #{timestamp_col_name}) IN (#{hours})"] unless hours.nil?

    countries = StringUtils.db_friendly_string_from_array countries, true unless countries.nil?
    
    all_conditions += ["(select country from #{edges_label}_detail where #{edges_label}_readings.id = #{edges_label}_detail.id) IN (#{countries})"] unless countries.nil?
    
    regions = StringUtils.db_friendly_string_from_array regions, true unless regions.nil?
    
    all_conditions += ["(select region from #{edges_label}_detail where #{edges_label}_readings.id = #{edges_label}_detail.id) IN (#{regions})"] unless regions.nil?
  
    locations = StringUtils.db_friendly_string_from_array locations, true unless locations.nil?
    
    all_conditions += ["(select locations_id from #{edges_label}_detail where #{edges_label}_readings.id = #{edges_label}_detail.id) IN (#{locations})"] unless locations.nil?
    
    select_string = case current_res
    	when "1" then "avg(#{value_col_name}), #{timestamp_col_name} as X, EXTRACT(year from #{timestamp_col_name}) as Y"
    	when "2" then "avg(#{value_col_name}), EXTRACT(doy from #{timestamp_col_name}) as X, EXTRACT(year from #{timestamp_col_name}) as Y"
    	when "3" then "avg(#{value_col_name}), EXTRACT(week from #{timestamp_col_name}) as X, EXTRACT(year from #{timestamp_col_name}) as Y"
    	when "4" then "avg(#{value_col_name}), EXTRACT(month from #{timestamp_col_name}) as X, EXTRACT(year from #{timestamp_col_name}) as Y"
    end
  
    
    
    #debugger #used to read the query 
    
    
    
    readings = reading_class.all(:select => select_string, :conditions => all_conditions.join(" AND "), :group => "X,Y", :order => "X,Y")
  
    #DEBT: FL: postgreSQL's "extract(week from date)" function uses the ISO8601 which means the 1st of jan can potentially be in week 52 (which is useful)
    #this does cause problems with the graph if someone sets the resolution to average weekly values.  
  
  end
  
  
  #simple function that re-samples the data less frequently   
  def FilterUtils.simple_resample data, new_size

  	sample_size = data.size / new_size
  	count=0
  	new_array = Array.new   	

  	until (count*sample_size) >= data.size 
  		new_array[count] = data[count*sample_size]
  		count=count+1
  	end  	
  	
	  return new_array  	
  end

  def FilterUtils.validate_both_start_end_present(params)
    start_date = params[:selected_start_date]
    end_date = params[:selected_end_date]

    errors = Array.new

    #check both start and end present are present
    if( ((start_date.nil? || start_date == "") && (end_date.nil? || end_date == "")))
      errors.push("You need to enter a start and end date.")
    end

    return errors

  end

  def FilterUtils.perform_start_end_date_validation(params)
    start_date = params[:selected_start_date]
    end_date = params[:selected_end_date]

    errors = Array.new
    start_date_object = Date.new
    end_date_object = Date.new

    #FL: allow user to only enter a start date and not an the end
    #check if either start or end present both are present
    #if( ((start_date.nil? || start_date == "") ^ (end_date.nil? || end_date == "")))
    #  errors.push("If you enter either a start or end date you must enter both.")
    #end

    #check date format valid
    begin
      if !(start_date.nil? || start_date == "")
        if (!TimeUtils.is_european_format(start_date))
          raise ArgumentError
        end
        start_date_object = TimeUtils.parse_european_date(start_date)
      end
    rescue ArgumentError
      errors.push("Start date is incorrectly formatted. Format is dd/mm/yyyy.")
    end

    begin
      if !(end_date.nil? || end_date == "")
        if (!TimeUtils.is_european_format(end_date))
          raise ArgumentError
        end
        end_date_object = TimeUtils.parse_european_date(end_date)
      end
    rescue ArgumentError
      errors.push("End date is incorrectly formatted. Format is dd/mm/yyyy.")
    end

    #check end date before start date
    if((not (end_date.nil? || end_date == "")) && (end_date_object < start_date_object))
      errors.push("End date must be after start date.")
    end

    return errors
  end

  #BoD TODO removed minute handling code to simplify db query, when we have time (no pun) put this back in
  #validations
  def FilterUtils.perform_filter_validation(params)
    start_time_hour = params[:selected_start_time_hour]
    #start_time_minute = params[:selected_start_time_minute]
    if !(params[:selected_start_time_am_pm].nil?)
      start_time_am_pm = params[:selected_start_time_am_pm][:value][0]
    else
      start_time_am_pm = ""
    end

    end_time_hour = params[:selected_end_time_hour]
    #end_time_minute = params[:selected_end_time_minute]
    if !(params[:selected_end_time_am_pm].nil?)
      end_time_am_pm = params[:selected_end_time_am_pm][:value][0]
    else
      end_time_as_pm = ""
    end

    errors = Array.new

    errors += FilterUtils.perform_start_end_date_validation(params)

    #check hours are valid
    if(FilterUtils.is_bad_number?(start_time_hour) || start_time_hour.to_i < 0 || start_time_hour.to_i > 11)
      errors.push("Start time hour must be between 0 and 11")
    end
    if(FilterUtils.is_bad_number?(end_time_hour) || end_time_hour.to_i < 0 || end_time_hour.to_i > 11)
      errors.push("End time hour must be between 0 and 11")
    end
    
    #check minutes are valid
    #if(start_time_minute.to_i < 0 || start_time_minute.to_i > 59)
    #  errors.push("Start time minutes must be between 0 and 59")
    #end
    #if(end_time_minute.to_i < 0 || end_time_minute.to_i > 59)
    #  errors.push("End time minutes must be between 0 and 59")
    #end
    
    #both hour and minute be present together
    #check if either start hour or minute present both are present
    #if( ((start_time_hour.nil? || start_time_hour == "") ^ (start_time_minute.nil? || start_time_minute == "")))
    #  errors.push("If you enter either a start hour or minute you must enter both.")
    #end
    
    #check if either start hour or minute present both are present
    #if( ((end_time_hour.nil? || end_time_hour == "") ^ (end_time_minute.nil? || end_time_minute == "")))
    #  errors.push("If you enter either a end hour or minute you must enter both.")
    #end
    
    #check if either start hour or minute present both are present
    if( ((end_time_hour.nil? || end_time_hour == "") ^ (start_time_hour.nil? || start_time_hour == "")))
      errors.push("If you enter either a end hour or start hour you must enter both.")
    end
    
    #check end time is after start time(these time objects have a default year and month)
    #BoD DEBT replace 0 with start_time_minute
    start_time_object = TimeUtils.create_time_object(start_time_hour, 0, start_time_am_pm)
    end_time_object = TimeUtils.create_time_object(end_time_hour, 0, end_time_am_pm)
    
    if(end_time_object < start_time_object)
      errors.push("End time must be after start time")
    end unless end_time_object.nil? || start_time_object.nil?
    return errors
  end

  def FilterUtils.format_errors(errors)
    formatted_errors = String.new

    errors.each {|ele|
      formatted_errors += " #{ele} <br/>";
    } unless errors.nil?

    return formatted_errors
  end

  def FilterUtils.is_bad_number?(number_string)
    if(number_string.nil? || number_string == "")
      return false
    end
    false if Integer(number_string) rescue true
  end
  
  def FilterUtils.filter_string_for_display(params)
    result = String.new

    current_res = FilterUtils.translate_array([params[:current_res]], [["Half hourly", "1"], ["Daily", "2"], ["Weekly", "3"], ["Monthly", "4"]])
    result += array_to_html "Current Res", current_res
    
    result += array_to_html "Meter Groups", FilterUtils.handle_selection_memory(params[:selected_meter_group]), MeterGroup
    result += array_to_html "Meters", FilterUtils.handle_selection_memory(params[:selected_meter]), Meter
    result += array_to_html "Years", FilterUtils.handle_selection_memory(params[:selected_year])
    
    months = FilterUtils.translate_array(FilterUtils.handle_selection_memory(params[:selected_month]), FilterUtils.get_month_hash)
    result += array_to_html "Months", months
        
    result += array_to_html "Days", FilterUtils.handle_selection_memory(params[:selected_day_of_month])
    
    days = FilterUtils.translate_array(FilterUtils.handle_selection_memory(params[:selected_day_of_week]), FilterUtils.get_days_of_week_hash)
    result += array_to_html "Weekdays", days
    
    result += array_to_html "Start Date", FilterUtils.handle_textfield_memory(params[:selected_start_date])
    result += array_to_html "End Date", FilterUtils.handle_textfield_memory(params[:selected_end_date])

    if(params[:selected_start_time_hour] != "")
      start_time = TimeUtils.create_time_object(FilterUtils.handle_textfield_memory(params[:selected_start_time_hour]), 0, FilterUtils.handle_selection_memory(params[:selected_start_time_am_pm]))
      result += "<span class=\"filter_label\"> Start Time:</span><span class=\"filter_params\"> '#{start_time.strftime("%I:%M%p")}'</span>" unless start_time.nil?
    end
    
    if(params[:selected_start_time_hour] != "")
      end_time = TimeUtils.create_time_object(FilterUtils.handle_textfield_memory(params[:selected_end_time_hour]), 0, FilterUtils.handle_selection_memory(params[:selected_end_time_am_pm]))
      result += "<span class=\"filter_label\"> End Time:</span><span class=\"filter_params\"> '#{end_time.strftime("%I:%M%p")}'</span>" unless end_time.nil?
    end
        
    result += array_to_html "Countries", FilterUtils.handle_selection_memory(params[:selected_country]), Country  
    result += array_to_html "Regions", FilterUtils.handle_selection_memory(params[:selected_region]), Region
    result += array_to_html "Locations", FilterUtils.handle_selection_memory(params[:selected_location]), Location 
    
    return result
  end
  
  def FilterUtils.array_to_html(label, array, clazz = nil)
    if(array != nil && array.size > 0)
      result = "<span class=\"filter_label\"> #{label}:</span><span class=\"filter_params\">"
        array.each {|ele|
          if(clazz != nil)
            item = clazz.find(ele)
            result += " '#{item.get_name}',"
          else
            result += " '#{ele.to_s}',"
          end
        } 
      result = result[0...-1]
      result += "</span>"
      return result
    else
      return ""
    end
  end
  
  def FilterUtils.translate_array(array, hash)
    result = Array.new
    
    if(array.nil? || hash.nil?)
      return Array.new
    else
      array.each{|array_item|
        hash.each{|hash_item|
          if(array_item == hash_item[1])
            result.push(hash_item[0])
          end
        }
      }
    end
    return result
  end
end