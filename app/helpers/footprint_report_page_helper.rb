module FootprintReportPageHelper

def status_colour_function x

     case x
   	 when 0  	
   	   status_colour = '<div id="status_text_red"> Incomplete </div>'
   	 when 1
   		status_colour = '<div id="status_text_orange"> On-going </div>'
   	 when 2
   		status_colour = '<div id="status_text_green"> Complete </div>'
   	 end 
 
end

end
