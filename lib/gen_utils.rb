class Time
  def step(other_time, increment)
   raise ArgumentError, "step can't be 0" if increment == 0
    increasing = self < other_time
    if (increasing && increment < 0) || (!increasing && increment > 0)
      yield self
      return
      end
      d = self
    begin
      yield d
      d += increment
    end while (increasing ? d <= other_time : d >= other_time)
  end

  def upto(other_time)
    step(other_time, 1) { |x| yield x }
  end
end
  
  
class GenUtils
  def GenUtils.data_output fuel_name, user_id, meter_id, input_value, start_date, end_date, output_file, increment_in_seconds, work_weekends_flag
    output = String.new
    now = Time.now	
    mm = 25
    hhm = 100
    temp = -1    
    monthly_modifier = half_hour_modifier = 0 
    
    x = 0.0;
    increments = (2.0* Math::PI ) / 17467.0    
	                      
    
    output = "INSERT INTO #{fuel_name}_readings (
					  start_time, 
					  mid_time, 
					  end_time, 					  
					  user_id, 
					  id, 
					  meter_id, 
					  #{fuel_name}_value, 
					  created_at, 
					  updated_at 
					  ) VALUES \n"
    
    
    
    start_date.step(end_date, increment_in_seconds) { |current_time|            
               

		half_hour_modifier = (rand * hhm - (hhm/2.0))
		
		is_weekend = ( current_time.advance(:seconds => ((increment_in_seconds)+(60*60*6))).strftime("%a") == "Sat" || current_time.strftime("%a") == "Sat"|| current_time.strftime("%a") == "Sun" || (current_time.advance(:seconds => ((increment_in_seconds)+(60*60*6))).strftime("%a") ) == "Mon" )	
		
		
		
		#if (!is_weekend || (is_weekend && work_weekends_flag))   
	  		value = ((Math.cos(x)/2.0) + 0.5) * 266.66 + 350  + monthly_modifier + half_hour_modifier
	  	#else #dont bother with weekends for gas
	  	#	value = 200.0 + monthly_modifier + half_hour_modifier
	  	#end
	  	
		x = x + increments   			
								                
		output = output + " (
					  '#{current_time}', 
					  '#{current_time.advance(:seconds => (increment_in_seconds/2.0))}', 
					  '#{current_time.advance(:seconds => increment_in_seconds)}', 
					  #{user_id}, 
					  nextval('#{fuel_name}_readings_id_seq'),
					  #{meter_id}, 
					  #{value},     
					  '#{now}', 
					  '#{now}'
						)," 
																		
		if(temp != current_time.month)
			temp = current_time.month 
			puts temp    
			monthly_modifier = ((rand * mm) - mm/2.0)		
			output_file.write(output)
			output = ""
		end										        	
    }
    
    output = output[0...-1]
    output = output + " ;\n"
    
    output_file.write(output)

 end
end	