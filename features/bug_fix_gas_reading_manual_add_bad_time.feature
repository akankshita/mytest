Feature: gas reading manual add time
	In order to manually enter or edit a gas reading time with bad dates
	As an user
	I want to enter a malformed date and not see an exception thrown

	Scenario: Create new gas reading with bad dates
		Given I have a meter with source type "Gas Readings"
		When I am logged in
		And I go to gas readings
		And I follow "enter new gas reading"
		And I fill in "gas_reading_gas_value" with "23456.7"
		And I fill in "gas_reading_start_time" with "12342134"
		And I fill in "gas_reading_end_time" with "2342342"
		And I select "kW/h" from "kwh_equivalents"
		And I select "barefield" from "gas_reading_meter"
		And I press "save"
		Then I should see "2 errors"
