class StatusHomeController < ApplicationController
  def index
    @hback = 'background:#37910E;margin-top:2px;height:36px;'
    @uback = ''
    @rback = ''
    @dback = ''
    @gback = ''
    @aback = ''
    @helpback = ''
    @documents_count = DocumentUpload.all.size


    ##### Electricity Cost Data #######
    elec_source_type = SourceType.first(:conditions => "name = 'Electrical Readings'")

    if (elec_source_type == nil or ElectricityReading.count == 0)
      @electricity_data = "[]"
      @electricity_categories = "[]"
    else
      jstring = "["
      jstring2 = "["

      #this query assumes the following two views: charges_day_monthly, charges_night_monthly
      rows = ElectricityReading.find_by_sql("select (charges_day_monthly.value*tariffs.day_rate + charges_night_monthly.value*tariffs.night_rate) as value, charges_day_monthly.X as X, charges_day_monthly.Y as Y from charges_day_monthly, charges_night_monthly, tariffs where charges_day_monthly.X = charges_night_monthly.X and charges_day_monthly.Y = charges_night_monthly.Y order by Y,X asc;")
      month_array = FilterUtils.get_month_array
      #build jstring
      rows.each_with_index do |current_row, index|

        #time_string = Time.parse(Time.local(current_row.attributes["y"], (current_row.attributes["x"].to_i  ), 15).to_s).to_i*1000 

        jstring += current_row.value + ","
        
        #jstring += "[#{time_string}, #{current_row.value}],"
        
        jstring2 += "\'" + month_array[ (current_row.attributes["x"].to_i) -1 ].to_s+ " " + current_row.attributes["y"] + "\',"

      end

      jstring2 = jstring2[0...-1]
      jstring2 += "]"
      @electricity_categories = jstring2

      jstring = jstring[0...-1]
      jstring += "]"
      @electricity_data = jstring

      
    end
    
   
    ##### Gas Cost Data #######
    gas_source_type = SourceType.first(:conditions => "name = 'Gas Readings'")

    if (gas_source_type == nil or GasReading.count == 0)
      @gas_data = "[]"
      @gas_categories = "[]"
    else
      jstring = "["
      jstring2 = "["

      #this query assumes the following two views: charges_day_monthly, charges_night_monthly
      rows = GasReading.find_by_sql("select (charges_day_monthly.value*tariffs.day_rate + charges_night_monthly.value*tariffs.night_rate) as value, charges_day_monthly.X as X, charges_day_monthly.Y as Y from charges_day_monthly, charges_night_monthly, tariffs where charges_day_monthly.X = charges_night_monthly.X and charges_day_monthly.Y = charges_night_monthly.Y order by Y,X asc;")
      month_array = FilterUtils.get_month_array
      #build jstring
      rows.each_with_index do |current_row, index|

        #time_string = Time.parse(Time.local(current_row.attributes["y"], (current_row.attributes["x"].to_i  ), 15).to_s).to_i*1000 

        jstring += current_row.value + ","
        
        #jstring += "[#{time_string}, #{current_row.value}],"
        
        jstring2 += "\'" + month_array[ (current_row.attributes["x"].to_i) -1 ].to_s+ " " + current_row.attributes["y"] + "\',"

      end

      jstring2 = jstring2[0...-1]
      jstring2 += "]"
      @gas_categories = jstring2

      jstring = jstring[0...-1]
      jstring += "]"
      @gas_data = jstring
     # render :text => @gas_data.inspect and return false
      @gas_data = "[1564,1706.00,1621,1824,1901,1810,1750,2010,2015,2020,2015,1910,1750,1810,2321,2464,2400,2500]"
      
    end    
    



=begin


    gas_source_type = SourceType.first(:conditions => "name = 'Gas Readings'")


    if (gas_source_type == nil or GasReading.count == 0)
      @gas_data = "[]"
    else
      jstring = "["   

      years = GasReading.find_by_sql("select extract(year from end_time) as year from gas_readings group by year order by year;")

      years.each do |current_year|
        if (!current_year.try("year").nil?)
          #get the rate, this will give you the user specified (unofficial) rate if it exists otherwise the official
          current_row = ConversionFactor.first(:conditions => "source_type_id = #{gas_source_type.id} AND year = #{current_year.year}", :order => "official asc", :limit => 1)
          if (current_row == nil)
            rate = 1.0 #DEBT: FL- this is a little unsatisfactory in the case where there isnt a conversion factor
          else
            rate = current_row.rate
          end

          #get the summed values for each day
          #rows = GasReading.find_by_sql("select sum(gas_value)*#{rate} as value, end_time from gas_readings where extract(year from end_time) = #{y.year} group by end_time order by end_time;" )

          rows = GasReading.find_by_sql("select sum(gas_value)*#{rate} as value, EXTRACT(month from end_time) as X, EXTRACT(year from end_time) as Y from gas_readings where extract(year from end_time) = #{current_year.year} group by X,Y order by X,Y; ")

          #thin out data if necessary
          rows = FilterUtils.simple_resample(rows, graph_max_points) if rows.size > graph_max_points
          @gas_data = []  
          #build jstring
          rows.each_with_index do |current_row, index| 
            #@gas_data << current_row.value
            jjstring += current_row.value
           # render :text => current_row.value.inspect and return false
            #jstring += "[Date.UTC(#{r.year}, #{r.month}, #{r.day}), #{r.value}],"
            time_string = Time.parse(Time.local(current_year.year, current_row.x, 1).to_s).to_i*1000 #Time.parse("#{r.x}").to_i*1000
            if(index==(rows.count-1) && Time.now.year.to_s == current_year.year)
              jstring += "{ x:#{time_string},  y: #{current_row.value}, color :'#F5B800'} "    
            else
              jstring += "[#{time_string}, #{current_row.value}],"
            end
          end
        end
      end
    end

            
      jjstring = jjstring[0...-1]
      jjstring += "]"
      @gas_data = @electricity_readings#"["+@gas_data +"]"

#render :text => @gas_data.inspect and return false

=end








    #######################







=begin 
    ##### Electricity Emission Data #######
    elec_source_type = SourceType.first(:conditions => "name = 'Electrical Readings'")

    if (elec_source_type == nil or ElectricityReading.count == 0)
      @electricity_emissions_data = "[]"
    else
      jstring = "["

      years = ElectricityReading.find_by_sql("select extract(year from end_time) as year from electricity_readings group by year order by year;")

      # sql query to convert kW to kW hours, taking in to account the duration the power is applied 
      calc_string = " sum((((extract(epoch from end_time)) - (extract(epoch from start_time))) / (extract(epoch from (interval '1 hour')))) * electricity_value) " 

      years.each do |current_year|
        if (!current_year.try("year").nil?)
          #get the rate, this will give you the user specified (unofficial) rate if it exists otherwise the official
          current_row = ConversionFactor.first(:conditions => "source_type_id = #{elec_source_type.id} AND year = #{current_year.year}", :order => "official asc", :limit => 1)
          if (current_row == nil)
            rate = 0.5490 #DEBT: dB - THIS CONVERSION FACTOR IS NOW AN AVERAGE TAKEN FROM THE LAST 22 YEARS
          else
            rate = current_row.rate
          end

          #get the summed values for each month
          rows = ElectricityReading.find_by_sql("select (#{calc_string}*#{rate/1000}) as value, EXTRACT(month from end_time) as X, EXTRACT(year from end_time) as Y from electricity_readings where extract(year from end_time) = #{current_year.year} group by X,Y order by X,Y; ")

          #thin out data if necessary
          rows = FilterUtils.simple_resample(rows, graph_max_points) if rows.size > graph_max_points

          #build jstring
          rows.each_with_index do |current_row, index|
            time_string = Time.parse(Time.local(current_year.year, current_row.x, 1).to_s).to_i*1000 #Time.parse("#{r.x}").to_i*1000        
            if(index==(rows.count-1) && Time.now.year.to_s == current_year.year)
              jstring += "{ x:#{time_string},  y: #{current_row.value}, color :'#6E9B2D'} "
            else
              jstring += "[#{time_string}, #{current_row.value}],"
            end  
          end
        end
      end

      jstring = jstring[0...-1]
      jstring += "]"
      @electricity_emissions_data = jstring
    end

    ####GAS data#####
    gas_source_type = SourceType.first(:conditions => "name = 'Gas Readings'")


    if (gas_source_type == nil or GasReading.count == 0)
      @gas_data = "[]"
    else
      jstring = "["

      years = GasReading.find_by_sql("select extract(year from end_time) as year from gas_readings group by year order by year;")

      years.each do |current_year|
        if (!current_year.try("year").nil?)
          #get the rate, this will give you the user specified (unofficial) rate if it exists otherwise the official
          current_row = ConversionFactor.first(:conditions => "source_type_id = #{gas_source_type.id} AND year = #{current_year.year}", :order => "official asc", :limit => 1)
          if (current_row == nil)
            rate = 1.0 #DEBT: FL- this is a little unsatisfactory in the case where there isnt a conversion factor
          else
            rate = current_row.rate
          end

          #get the summed values for each day
          #rows = GasReading.find_by_sql("select sum(gas_value)*#{rate} as value, end_time from gas_readings where extract(year from end_time) = #{y.year} group by end_time order by end_time;" )

          rows = GasReading.find_by_sql("select sum(gas_value)*#{rate} as value, EXTRACT(month from end_time) as X, EXTRACT(year from end_time) as Y from gas_readings where extract(year from end_time) = #{current_year.year} group by X,Y order by X,Y; ")

          #thin out data if necessary
          rows = FilterUtils.simple_resample(rows, graph_max_points) if rows.size > graph_max_points

          #build jstring
          rows.each_with_index do |current_row, index|
            #jstring += "[Date.UTC(#{r.year}, #{r.month}, #{r.day}), #{r.value}],"
            time_string = Time.parse(Time.local(current_year.year, current_row.x, 1).to_s).to_i*1000 #Time.parse("#{r.x}").to_i*1000
            if(index==(rows.count-1) && Time.now.year.to_s == current_year.year)
              jstring += "{ x:#{time_string},  y: #{current_row.value}, color :'#F5B800'} "    
            else
              jstring += "[#{time_string}, #{current_row.value}],"
          end
        end
      end
    end

            
      jstring = jstring[0...-1]
      jstring += "]"
      @gas_data = jstring


      ####Footprint report progress bar
      ##[incomplete, on-going, complete]
      total_tasks = 7
      votes = Array.new
      votes = [0, 0, 0]

      votes[DesignatedChangesTask.first.status] += 1 unless FootprintReport.first.nil?
      votes[CcaExemptionsTask.first.status] += 1 unless FootprintReport.first.nil?
      votes[ReconfirmationExemptionTask.first.status] += 1 unless FootprintReport.first.nil?
      votes[EnergyMetricsTask.first.status] += 1 unless FootprintReport.first.nil?
      votes[EmissionMetricsTask.first.status] += 1 unless FootprintReport.first.nil?
      votes[ResidualEmissionsTask.first.status] += 1 unless FootprintReport.first.nil?
      votes[OtherFuelsTask.first.status] += 1 unless FootprintReport.first.nil?

      jstring = ((votes[0] * 100.0) / total_tasks).to_s + ", "
      jstring += ((votes[1] * 100.0) / total_tasks).to_s + ", "
      jstring += ((votes[2] * 100.0) / total_tasks).to_s

      @footprint_report_progress = jstring
      @footprint_string = votes[2].to_s + " out of " + total_tasks.to_s + " tasks complete"

      ####Annual report progress bar
      total_tasks = 9
      votes = [0, 0, 0]

      votes[CcaExemptionsTask.first.status] += 1 unless FootprintReport.first.nil?
      votes[RenewableTask.first.status] += 1 unless AnnualReport.first.nil?
      votes[ConfirmEnergySupplyTask.first.status] += 1 unless AnnualReport.first.nil?
      votes[ReportOtherFuelsTask.first.status] += 1 unless AnnualReport.first.nil?
      votes[ElectricityGeneratingCreditsTask.first.status] += 1 unless AnnualReport.first.nil?
      votes[SignificantGroupUndertakingsTask.first.status] += 1 unless AnnualReport.first.nil?
      votes[EarlyActionMetricTask.first.status] += 1 unless AnnualReport.first.nil?
      votes[GrowthMetricTask.first.status] += 1 unless AnnualReport.first.nil?
      votes[DisclosureTask.first.status] += 1 unless AnnualReport.first.nil?

      jstring = ((votes[0] * 100.0) / total_tasks).to_s + ", "
      jstring += ((votes[1] * 100.0) / total_tasks).to_s + ", "
      jstring += ((votes[2] * 100.0) / total_tasks).to_s

      @annual_report_progress = jstring
      @annual_string = votes[2].to_s + " out of " + total_tasks.to_s + " tasks complete"
    end

=end 

    ####last login
    @lastlogon = nil
    last_user = User.all(:conditions => "current_login_at is not null AND username != 'emm_admin' AND username != 'data_entry_bot'", :order => "current_login_at desc").first
    if(last_user.nil?)
      @lastlogon = "No user login details available"
    else
      @lastlogon = "Last user logged in: \"#{last_user.username}\" at time: \"#{TimeUtils.to_uk_s(TimeUtils.make_gmt(last_user.current_login_at))}\" from ip \"#{last_user.current_login_ip}\""
    end

  end
end
