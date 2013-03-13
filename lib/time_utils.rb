class TimeUtils 
  
  def TimeUtils.find_mid_time(start_date, end_date)
    mid_time = Time.new
    start_time = Time.parse(start_date.to_s)
    end_time = Time.parse(end_date.to_s)
    number_of_seconds = (end_time - start_time) / 2
    mid_time = start_time + number_of_seconds
  end
  
  def TimeUtils.convert_to_js_timestamp(time_object)
     result = time_object.to_i * 1000
  end
  
  def TimeUtils.convert_js_timestamp_to_db_string(javascript_timestamp)
    if(!javascript_timestamp.nil?)
      javascript_timestamp = javascript_timestamp.slice(0..-4)
      as_number = javascript_timestamp.to_i
      time_object = Time.at(as_number)
      return time_object.to_s(:db)
    end
  end
  
  def TimeUtils.flip_day_and_month_fields(date_string)
    #assumes a format like " MM/DD/YYYY HH:MM"
    parts = date_string.split("/")
    temp=parts[0]
    parts[0]=parts[1].strip
    parts[1]=temp.strip
    return parts.join("/")
  end
  
  def TimeUtils.parse_european_date(date_string)
    if(date_string.nil? || date_string =="")
      return nil
    end
    if(!TimeUtils.is_european_format(date_string))
      return date_string
    end
    european_date = '%d/%m/%Y'
  	Date.strptime(date_string, european_date)
  end
  
  def TimeUtils.parse_american_date(date_string)
    if(date_string.nil? || date_string =="")
      return nil
    end
    if(!TimeUtils.is_american_format(date_string))
      return date_string
    end
    american_date = '%Y/%d/%m'
  	Date.strptime(date_string, american_date)
  end

  def TimeUtils.parse_unix_date(date_string)
    if(date_string.nil? || date_string =="")
      return nil
    end
    if(!TimeUtils.is_unix_format(date_string))
      return date_string
    end
    unix_date = '%Y-%m-%d'
  	Date.strptime(date_string, unix_date)
  end
  
  def TimeUtils.is_european_format(date_string)
    if ((date_string =~ %r{(\d{1,2})(/)(\d{1,2})(/)(\d{4})}) == nil)
      return false
    end
    true
  end
  
  def TimeUtils.is_american_format(date_string)
    if ((date_string =~ %r{(\d{4})(/)(\d{1,2})(/)(\d{1,2})}) == nil)
      return false
    end
    true
  end

  def TimeUtils.is_unix_format(date_string)
    if ((date_string =~ %r{(\d{4})(-)(\d{1,2})(-)(\d{1,2})}) == nil)
      return false
    end
    true
  end

  def TimeUtils.parse_european_date_as_time(date_string, hour_string = nil, minute_string = nil)
    date = TimeUtils.parse_european_date(date_string)
    begin
      if(!date.nil? || !date.is_a?(String))
        date_time = date.to_datetime
        if(!hour_string.nil?)
          date_time = date_time.change(:hour => hour_string.to_i)
        end
        if(!minute_string.nil?)
          date_time = date_time.change(:min => minute_string.to_i)
        end

        date_time.to_s
      else
        date
      end
    rescue ArgumentError
      return nil
    end
  end
  
  def TimeUtils.convert(element, current_res)     
   
  	timestamp = case current_res
  		when "1" then Time.parse(element.attributes["x"]).to_i * 1000
  		when "2" then ((Time.mktime(element.attributes["y"].to_i,1,1)+(element.attributes["x"].to_i).days.to_i).to_i) *1000
  		when "3" then ((Time.mktime(element.attributes["y"].to_i,1,1)+(element.attributes["x"].to_i).weeks.to_i).to_i) *1000
  		when "4" then ((Time.mktime(element.attributes["y"].to_i,1,1)+(element.attributes["x"].to_i).months.to_i).to_i) *1000
  		else ""
  	end
  	
  	return timestamp
  end

  def TimeUtils.create_time_object(hour, minute, am_pm)
    if((hour.nil? || hour == "") || (minute.nil? || minute ==""))
      return nil
    end
    hour = hour.to_i unless hour.nil?
    minute = minute.to_i unless minute.nil?
    am_pm = am_pm[0].to_i unless am_pm.nil?
    
    if(am_pm.to_i == 1)
      hour = hour.to_i + 12
    end
    
    #Time.mktime( year, month, day, hour, min, sec, usec )
    result = Time.mktime( 0, 1, 1, hour, minute, 0, 0)
  end
  
  def TimeUtils.get_hours(start_time, end_time)
    begin
      if(start_time.nil? || end_time.nil?)
        return Array.new
      else
        return Array(start_time.hour..end_time.hour)
      end
    rescue NoMethodError
      return Array.new
    end
  end
  
  def TimeUtils.to_uk_s(date_object)
    date_object.strftime("%d/%m/%Y %H:%M:%S") unless date_object.nil?
  end

  def TimeUtils.to_uk_date_s(date_object)
    date_object.strftime("%d/%m/%Y") unless date_object.nil?
  end


  def TimeUtils.make_hours
    array_of_hours = Array.new 
		(0..23).each {|ele| array_of_hours.push(ele.to_s)}
		return array_of_hours
  end
  
  def TimeUtils.make_minutes
    array_of_minutes = ["00", "15", "30", "45"]
  end

  def TimeUtils.make_gmt(date_object)
    result = nil
    result = Time.at(date_object + Time.zone_offset('GMT')) unless date_object.nil? || date_object.class != Time
    return result
  end
 
end