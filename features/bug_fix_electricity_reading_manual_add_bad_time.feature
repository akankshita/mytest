Feature: electricity reading manual add time
	In order to manually enter or edit a electricity reading time with bad dates
	As an user
	I want to enter a malformed date and not see an exception thrown

	Scenario: bad date format
		Given I have a meter with source type "Electrical Readings"
		When I am logged in
		And I go to electricity readings
		And I follow "enter new electricity reading"
		And I fill in "electricity_reading_electricity_value" with "2342"
		And I fill in "electricity_reading_start_time" with "asdfadsf"
		And I fill in "electricity_reading_end_time" with "asdfasdf"
		And I select "barefield" from "electricity_reading_meter"
		And I press "Save"
		Then I should see "2 errors"
