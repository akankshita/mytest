Given /^I have meter group called (.+) and meter called (.+) which are siblings$/ do |meter_group_name, meter_name|
  region = Region.create(:name => "Testing Data Region")
  region.save
  
  location = Location.create()    
  location.region = region
  location_node = NodeEntry.new(:name => "Testing Data Location")
  location_node.node = location
  location.node_entry = location_node
  location.save
  
  source_type = SourceType.create(:name => "Gas Readings")
  source_type.save

  source_type2 = SourceType.create(:name => "Electrical Readings")
  source_type2.save
  
  meter = Meter.create(:meter_identifier => "blah", :source_type => source_type)
  meter_node = NodeEntry.create(:name => meter_name)
  meter_node.parent = location_node
  meter.node_entry = meter_node
  meter.save
  
  meter_group = MeterGroup.create()
  meter_group_node = NodeEntry.create(:name => meter_group_name)
  meter_group_node.parent = location_node
  meter_group.node_entry = meter_group_node
  meter_group.save

  meter = Meter.create(:meter_identifier => "blah2", :source_type => source_type)
  meter_node2 = NodeEntry.create(:name => "#{meter_name}_2")
  meter_node2.parent = meter_group_node
  meter.node_entry = meter_node2
  meter_node2.node = meter
  meter_node2.save
  meter.save
  
  #a.errors.each {|k, v| puts "#{k.capitalize}: #{v}"}
end

Given /^I have gas data for meter group (.+) and meter (.+)$/ do |meter_group_name, meter_name|
  month = 30
  
  user = create_user

  start_time = Date.civil(2010,1,1).to_datetime
  end_time = Date.civil(2010,2,1).to_datetime
  
  gas_reading1 = GasReading.create(:user => user, :start_time => start_time, :end_time => end_time, :gas_value => 250, :meter => Meter.first(:conditions => {:meter_identifier => "blah"}))
  gas_reading1.save
  
  gas_reading2 = GasReading.create(:user => user, :start_time => start_time - 2 * month, :end_time => DateTime.now - month, :gas_value => 500, :meter => Meter.first(:conditions => {:meter_identifier => "blah2"}))
  gas_reading2.save
end

Given /^I have gas data with value "([^"]*)" for meter group "([^"]*)" and meter "([^"]*)"$/ do |value, meter_group_name, meter_name|
  Given "I have gas data for meter group #{meter_group_name} and meter #{meter_name}"

  value_decimal = value.to_d

  gas_readings = GasReading.all
  gas_readings.each { |current_gas_reading|
    current_gas_reading.gas_value = value_decimal
    assert_saved(current_gas_reading)
  }
end


Given /^I have electricity data for meter group (.+) and meter (.+)$/ do |meter_group_name, meter_name|
  month = 30

  user = create_user

  start_time = Date.civil(2010,4,6).to_datetime
  end_time = Date.civil(2010,4,10).to_datetime

  electricity_reading1 = ElectricityReading.create(:user => user, :start_time => start_time, :end_time => end_time, :electricity_value => 250, :meter => Meter.first(:conditions => {:meter_identifier => "blah"}))
  electricity_reading1.save

  electricity_reading2 = ElectricityReading.create(:user => user, :start_time => start_time, :end_time => end_time, :electricity_value => 500, :meter => Meter.first(:conditions => {:meter_identifier => "blah2"}))
  electricity_reading2.save
end

Given /^I have electricity data with value "([^"]*)" for meter group "([^"]*)" and meter "([^"]*)"$/ do |value, meter_group_name, meter_name|
  Given "I have electricity data for meter group #{meter_group_name} and meter #{meter_name}"

  value_decimal = value.to_d

  electricity_readings = ElectricityReading.all
  electricity_readings.each { |current_reading|
    current_reading.electricity_value = value_decimal
    assert_saved(current_reading)
  }
end


Then /^I should see (\d+) data points$/ do |size|
  if(!response.body.include?("<>DataCount<><>#{size}<>"))
    raise Exception.new("Did not have #{size} data points")
  end
end

Then /^I should see (\d+) months with data points$/ do |size|
  if(!response.body.include?("<>months_with_data<><>#{size}<>"))
    raise Exception.new("Did not have #{size} months with data")
  end
end

Then /^I should see data with two decimal points$/ do
  if(!response.body.include?("var data = [750.0]"))
     raise Exception.new("Data was not reduced to two decimal places")
  end
end



When /^I print html$/ do
   puts "#{response.body}"
end

Given /^I have a controller display name for "([^"]*)"$/ do |display_name|
   ControllerDisplayName.create(:controller_name => GasSummaryController.controller_name, :display_name => "Gas Totals")
end





