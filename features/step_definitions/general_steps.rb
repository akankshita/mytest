When /^I am logged in$/ do
  create_user("rover","rover","rover@rover.com")

  visit("/login")
  fill_in("user_session_username", :with => "rover")
  fill_in("user_session_password", :with => "rover")
  click_button("login")
  response.should contain("Successfully logged in")
end

When /^I debug$/ do
  debugger
end

Given /^I have a user with user "([^"]*)" and password "([^"]*)"$/ do |user, password|
  create_user(user, password, "rover@rover.com")
end

Given /^I have a gas upload file$/ do
 user = create_user

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
  
  meter = Meter.create(:meter_identifier => "blah", :source_type => source_type)
  meter_node = NodeEntry.create(:name => "barefield")
  meter_node.parent = location_node
  meter.node_entry = meter_node
  meter.save
  
  gas_upload = GasUpload.create(:filename => "test", :meter => meter, :user => user, :interval => 60)
  gas_upload
end

Given /^I have an electricity meter$/ do
  user = create_user

  region = Region.create(:name => "Testing Data Region")
  region.save
  
  location = Location.create(:region => region)    
  location_node = NodeEntry.new(:name => "Testing Data Location")
  location_node.node = location
  location.node_entry = location_node
  location_node.save
  location.save
  
  source_type = SourceType.create(:name => "Electrical Readings")
  source_type.save
  
  meter = Meter.create(:meter_identifier => "blah", :source_type => source_type)
  meter_node = NodeEntry.create(:name => "barefield")
  meter_node.parent = location_node
  meter.node_entry = meter_node
  meter_node.save
  meter.save
    
  t = Time.now.to_s(:db)
  kwh_equivalent = KwhEquivalent.create(:source_type => source_type, :name => 'kW/h', :conversion_factor => 1)
  kwh_equivalent.save
end

Given /^I have a meter with source type "([^"]*)"$/ do |arg1|
  user = create_user

  region = Region.create(:name => "Testing Data Region")
  region.save
  
  location = Location.create(:region => region)    
  location_node = NodeEntry.new(:name => "Testing Data Location")
  location_node.node = location
  location.node_entry = location_node
  location_node.save
  location.save
  
  source_type = SourceType.create(:name => arg1)
  source_type.save
  
  meter = Meter.create(:meter_identifier => "blah", :source_type => source_type)
  meter_node = NodeEntry.create(:name => "barefield")
  meter_node.parent = location_node
  meter.node_entry = meter_node
  meter_node.save
  meter.save
  
  t = Time.now.to_s(:db)
  kwh_equivalent = KwhEquivalent.create(:source_type => source_type, :name => 'kW/h', :conversion_factor => 1)
  kwh_equivalent.save
end

Given /^I have an electricity reading$/ do
  start_time = Date.civil(2010,1,1)
  mid_time = Date.civil(2010, 1,15)
  end_time = Date.civil(2010,2,1)
  electricity_reading = ElectricityReading.create(:meter => Meter.first, :start_time => start_time, :end_time => end_time, :mid_time => mid_time, :electricity_value => 4123, :user => User.first)
  assert_saved(electricity_reading)
end

Given /^I have an app config object with gas and crc turned off$/ do
  app_config = AppConfig.create(:gas => false, :crc => false)
  assert_saved(app_config)
end

