class GasDetailController < ApplicationController

  def index
    if (params[:selected_start_date] == nil)
      start_date = Date.civil(1000, 1, 1).to_s(:db)
      end_date = Date.civil(3000, 1, 1).to_s(:db)
    else
      @current_selected_start_date = FilterUtils.handle_textfield_memory(params[:selected_start_date])
      @current_selected_end_date = FilterUtils.handle_textfield_memory(params[:selected_end_date])

      start_date = TimeUtils.parse_european_date(params[:selected_start_date])
      end_date = TimeUtils.parse_european_date(params[:selected_end_date])

      result = Array.new
      errors = Array.new
      errors += FilterUtils.perform_start_end_date_validation(params)
      errors += FilterUtils.validate_both_start_end_present(params)
      if errors.size > 0
        flash[:notice] = FilterUtils.format_errors(errors)
        return
      end

    end


####Comparison by Months
    values = Array.new
    names = Array.new

    result = GasReading.find_by_sql("select sum(gas_value) as value, extract(month from end_time) as month from gas_readings where start_time >= '#{start_date}' AND end_time <= '#{end_date}'  group by month order by month;")
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

    result = GasReading.find_by_sql("select sum(gas_value) as value, extract(year from end_time) as year from gas_readings where start_time >= '#{start_date}' AND end_time <= '#{end_date}'  group by year order by year;")

    result.each do |k|
      values.push(k.value)
      names.push("'"+k.year+"'")
    end

    @year_data = StringUtils.generate_json_array_without_timestamp(values, "data")
    @year_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")


####meters
    result = Array.new
    values = Array.new
    names = Array.new

    result = GasReading.all(:select => "sum(gas_value) AS sum, node_entries.name AS name", :from => "gas_readings, meters, node_entries", :conditions => "gas_readings.meter_id = meters.id AND gas_readings.meter_id = node_entries.node_id AND node_entries.node_type = 'Meter' AND start_time >= '#{start_date}' AND end_time <= '#{end_date}'", :group => "gas_readings.meter_id, node_entries.name", :order => "meter_id")
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
        values.push(result.first.sum)
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
        values.push(result.first.sum)
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
        values.push(result.first.sum)
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
          values.push(result.first.sum)
          names.push("'"+c.name+"'")
        end
      end
    end

    @country_data = StringUtils.generate_json_array_without_timestamp(values, "data")
    @country_categories = StringUtils.generate_json_array_without_timestamp(names, "categories")

  end

end
