class ProfilesController < ApplicationController
  def index


    ############################################
    #Date filters 
    
     
     #end date
     if(params[:selected_end_date] == nil || params[:selected_end_date] == '')
    	  end_date = Date.civil(3000,1,1).to_s(:db)
     else
        @current_selected_end_date = FilterUtils.handle_textfield_memory(params[:selected_end_date])
        end_date = TimeUtils.parse_european_date(params[:selected_end_date])
     end

     #start date
    if(params[:selected_start_date] == nil || params[:selected_start_date] == '')
    	 start_date = Date.civil(1000,1,1).to_s(:db)
    else
      @current_selected_start_date = FilterUtils.handle_textfield_memory(params[:selected_start_date])
      start_date = TimeUtils.parse_european_date(params[:selected_start_date])
      
      result = Array.new
      errors = Array.new
      errors += FilterUtils.perform_start_end_date_validation(params)
      if errors.size > 0
          flash[:notice] = FilterUtils.format_errors(errors)
          return
      end
    end






    ############################################
    #Average daily profile
    
    #sql statment:  "select stddev(electricity_value)+avg(electricity_value) as upper, avg(electricity_value) as avg,avg(electricity_value)-stddev(electricity_value) as lower, extract(min from end_time) as M, extract(hour from end_time) as H from electricity_readings where extract(dow from end_time) in (1,2,3,4,5) group by H,M order by H,M;"
    
    axis = ElectricityReading.all(:select => "extract (hour from end_time) as H, extract (min from end_time) as M", :conditions => " start_time >= '#{start_date}' AND end_time <= '#{end_date}' ", :group =>"H,M", :order => "H,M") 
    
    select_string = "stddev(electricity_value)+avg(electricity_value) as upper, avg(electricity_value) as avg,avg(electricity_value)-stddev(electricity_value) as lower, extract(min from end_time) as M, extract(hour from end_time) as H "
    where_string = " start_time >= '#{start_date}' AND end_time <= '#{end_date}' AND  extract(dow from end_time) in (1,2,3,4,5)"
    
    readings = ElectricityReading.all(:select => select_string, :conditions => where_string, :group => "H,M", :order => "H,M")

    lower = "daily_lower = [ "
    avg = "daily_avg = [ "
    upper = "daily_upper = [ "
    time = "daily_time = [ "
    
    axis.each{ |x|
      time = time + "\'#{x.h.to_s.rjust(2,"0")}:#{x.m.to_s.rjust(2,"0")}\',"  
    }
    
    readings.each{ |x|
      lower = lower + "#{x.lower},"
      avg = avg + "#{x.avg},"
      upper = upper + "#{x.upper}," 
    }
    
    @daily_time = time[0...-1] + "]"
    @daily_lower = lower[0...-1] + "]"
    @daily_avg = avg[0...-1] + "]"
    @daily_upper = upper[0...-1] + "]"
    
    
    ############################################
    #Average weekly profile
    
    #sql: "select stddev(electricity_value)+avg(electricity_value) as upper, avg(electricity_value) as avg,avg(electricity_value)-stddev(electricity_value) as lower, extract (dow from end_time) as D, extract(min from end_time) as M, extract(hour from end_time) as H from electricity_readings group by D,H,M order by D,H,M;"
    
    axis = ElectricityReading.all(:select => "extract (dow from end_time) as D, extract (hour from end_time) as H, extract (min from end_time) as M", :conditions => " start_time >= '#{start_date}' AND end_time <= '#{end_date}' ", :group =>"D,H,M", :order => "D,H,M") 
    
    select_string = "stddev(electricity_value)+avg(electricity_value) as upper, avg(electricity_value) as avg, avg(electricity_value)-stddev(electricity_value) as lower, extract (dow from end_time) as D, extract(min from end_time) as M, extract(hour from end_time) as H "
    where_string = " start_time >= '#{start_date}' AND end_time <= '#{end_date}'"
    readings = ElectricityReading.all(:select => select_string, :conditions => where_string, :group => "D,H,M", :order => "D,H,M")

    lower = "weekly_lower = [ "
    avg = "weekly_avg = [ "
    upper = "weekly_upper = [ "
    time = "weekly_time = [ "
    
    dow = FilterUtils.get_abv_days_of_week_hash
    axis.each{ |x|
      time = time + "\'#{dow[x.d.to_i].first} #{x.h.to_s.rjust(2,"0")}:#{x.m.to_s.rjust(2,"0")}\',"  
    }
    
    readings.each{ |x|
      lower = lower + "#{x.lower},"
      avg = avg + "#{x.avg},"
      upper = upper + "#{x.upper}," 
    }
    
    @weekly_time = time[0...-1] + "]"
    @weekly_lower = lower[0...-1] + "]"
    @weekly_avg = avg[0...-1] + "]"
    @weekly_upper = upper[0...-1] + "]"


  end

end



