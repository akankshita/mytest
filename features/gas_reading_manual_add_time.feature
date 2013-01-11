Feature: gas reading manual add time
	In order to manually enter or edit a gas reading time
	As an user
	I want to be able to have a set of pages to view edit and create gas readings with custom times

	Scenario: Create new gas reading with default time 00:00:00
		Given I have a meter with source type "Gas Readings"
		When I am logged in
		And I go to gas readings
		And I follow "enter new gas reading"
		And I fill in "gas_reading_gas_value" with "23456.7"
		And I fill in "gas_reading_start_time" with "16/02/2011"
		And I fill in "gas_reading_end_time" with "24/02/2011"
		And I select "kW/h" from "kwh_equivalents"
		And I select "barefield" from "gas_reading_meter"
		And I press "save"
		Then I should see "Gas reading was successfully created." 
		And I should see "Manual Entry"
		And I should see "16/02/2011 00:00:00"
		And I should see "24/02/2011 00:00:00"
		And I should see "barefield"
	
	Scenario: Create new gas reading with custom time 00:00:00
		Given I have a meter with source type "Gas Readings"
		When I am logged in
		And I go to gas readings
		And I follow "enter new gas reading"
		And I fill in "gas_reading_gas_value" with "23456.7"
		And I fill in "gas_reading_start_time" with "16/02/2011"
		And I select "14" from "gas_reading_start_hour"
		And I select "15" from "gas_reading_start_minute"
		And I fill in "gas_reading_end_time" with "24/02/2011"
		And I select "21" from "gas_reading_end_hour"
		And I select "45" from "gas_reading_end_minute"
		And I select "kW/h" from "kwh_equivalents"
		And I select "barefield" from "gas_reading_meter"
		And I press "save"
		Then I should see "Gas reading was successfully created." 
		And I should see "Manual Entry"
		And I should see "16/02/2011 14:15:00"
		And I should see "24/02/2011 21:45:00"
		And I should see "barefield"

  Scenario: Create new gas reading with same start and end date but different times
		Given I have a meter with source type "Gas Readings"
		When I am logged in
		And I go to gas readings
		And I follow "enter new gas reading"
		And I fill in "gas_reading_gas_value" with "23456.7"
		And I fill in "gas_reading_start_time" with "24/02/2011"
		And I select "14" from "gas_reading_start_hour"
		And I select "15" from "gas_reading_start_minute"
		And I fill in "gas_reading_end_time" with "24/02/2011"
		And I select "21" from "gas_reading_end_hour"
		And I select "45" from "gas_reading_end_minute"
		And I select "kW/h" from "kwh_equivalents"
		And I select "barefield" from "gas_reading_meter"
		And I press "save"
		Then I should see "Gas reading was successfully created." 
		And I should see "Manual Entry"
		And I should see "24/02/2011 14:15:00"
		And I should see "24/02/2011 21:45:00"
		And I should see "barefield"
		
	Scenario: See error when gas reading has start time after end time
		Given I have a meter with source type "Gas Readings"
		When I am logged in
		And I go to gas readings
		And I follow "enter new gas reading"
		And I fill in "gas_reading_gas_value" with "23456.7"
		And I fill in "gas_reading_start_time" with "24/02/2011"
		And I select "21" from "gas_reading_start_hour"
		And I select "15" from "gas_reading_start_minute"
		And I fill in "gas_reading_end_time" with "24/02/2011"
		And I select "18" from "gas_reading_end_hour"
		And I select "45" from "gas_reading_end_minute"
		And I select "kW/h" from "kwh_equivalents"
		And I select "barefield" from "gas_reading_meter"
		And I press "save"
		Then I should see "Start time must be after End time"
	
	Scenario: See error when gas reading has same start and end time
	  Given I have a meter with source type "Gas Readings"
		When I am logged in
		And I go to gas readings
		And I follow "enter new gas reading"
		And I fill in "gas_reading_gas_value" with "23456.7"
		And I fill in "gas_reading_start_time" with "24/02/2011"
		And I select "21" from "gas_reading_start_hour"
		And I select "15" from "gas_reading_start_minute"
		And I fill in "gas_reading_end_time" with "24/02/2011"
		And I select "21" from "gas_reading_end_hour"
		And I select "15" from "gas_reading_end_minute"
		And I select "kW/h" from "kwh_equivalents"
		And I select "barefield" from "gas_reading_meter"
		And I press "save"
		Then I should see "Start time must be after End time"