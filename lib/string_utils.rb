class StringUtils
  def StringUtils.generate_json_array(input_array, javascript_array_name, current_res, max_min)
    result = "var #{javascript_array_name} = ["
    if input_array.length > 0
      input_array.each { |current_element| 
      	timestamp = TimeUtils.convert(current_element, current_res)
        if(timestamp > max_min[0])
          max_min[0] = timestamp
        end
      	if(max_min[1] == 0)
      	  max_min[1] = timestamp
    	  end
        if(timestamp < max_min[1])
          max_min[1] = timestamp
        end
        result += "[#{timestamp}, #{current_element.avg}],"
      }
      #cut off the last trailing comma and close the square brackets
      result = result[0...-1] + "]"
    else
      result += "]"
    end

  end
  
  def StringUtils.generate_json_array_without_timestamp(input_array, javascript_array_name)
    result = "var #{javascript_array_name} = ["
    if input_array.length > 0
      input_array.each { |current_element| 
        begin
          float =  Float(current_element)
          formatted_float = float.round_with_precision(2)
          result += "#{formatted_float},"
        rescue ArgumentError
          result += "#{current_element},"
        end
      }
      #cut off the last trailing comma and close the square brackets
      result = result[0...-1] + "]"
    else
      result += "]"
    end
  end
  
  def StringUtils.db_friendly_string_from_array array, with_quotes = false
    result = String.new  
    array.each {|ele| 
      if (with_quotes)
        result += "'#{ele}'," 
      else
        result += "#{ele}," 
      end
    } unless array.nil?
    result = result.chop
    
    if(result == "")
      return nil
    else
      return result
    end
    
  end
end