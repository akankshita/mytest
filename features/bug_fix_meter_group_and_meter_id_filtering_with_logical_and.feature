Feature: Bug fix meter group and meter id filtering with logical and
	In order to filter by meter groups and meter ids
	As an user
	I want to be able to filter with logical and behavior between meter groups and meter id filters

	Scenario: Gas Filtering
		Given I have meter group called floor_4 and meter called gas_meter which are siblings
		And I have gas data for meter group floor_4 and meter gas_meter
		When I am logged in 
		And I go to gas totals
		Then I should see 2 data points
		When I select "floor_4" from "selected_meter_group_value"
		And I select "gas_meter" from "selected_meter_value"
		And I press "Apply Filters"
		Then I should see 0 data points