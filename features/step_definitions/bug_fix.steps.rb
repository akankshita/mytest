Given /^I have a location$/ do

  region = Region.create(:name => "Clare")
  region.save

  location = Location.create()    
  location.region = region
  location_node = NodeEntry.new(:id => 123, :name => "Barefield")
  location_node.node = location
  location.node_entry = location_node
  location.save
  
  source_type = SourceType.create(:name => "Gas Readings")
  source_type.save

end

Given /^I have both source types$/ do
  source_type = SourceType.create(:name => "Gas Readings")
  source_type.save

  source_type2 = SourceType.create(:name => "Electrical Readings")
  source_type2.save
end

Then /^I should have a meter called "([^"]*)" with identifier "([^"]*)"$/ do |name, meter_identifer|
  if(Meter.first.nil?)
    raise Exception.new("meter not created")
  end
  if(!Meter.first.node_entry.name == name)
    raise Exception.new("name not set")
  end
  if(!Meter.first.meter_identifier == meter_identifer)
    raise Exception.new("meter identifier not set")
  end
  if(!Meter.first.source_type == SourceType.first)
    raise Exception.new("source_type not set")
  end
end

Then /^I should have a meter group called "([^"]*)"$/ do |name|
   if(MeterGroup.first.nil?)
    raise Exception.new("meter group not created")
  end
  if(!MeterGroup.first.node_entry.name == name)
    raise Exception.new("name not set")
  end
end

Then /^I should see the correctly formated end date$/ do
  if(!response.body.include?(TimeUtils.to_uk_s(GasReading.first.end_time)))
    raise Exception.new("time date not there")
  end
end

