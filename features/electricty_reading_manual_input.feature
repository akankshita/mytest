Feature: electricity reading manual input
	In order to manually enter or edit an electricity readings
	As an user
	I want to be able to have a set of pages to view edit and create electricity readings
	
	Scenario: create electricity reading
		Given I have a meter with source type "Electrical Readings"
		When I am logged in 
		And I go to electricity readings
		And I follow "enter new electricity reading"
		And I fill in "electricity_reading_electricity_value" with "2342"
		And I fill in "electricity_reading_start_time" with "13/11/2010"
		And I fill in "electricity_reading_end_time" with "19/11/2010"
		And I select "barefield" from "electricity_reading_meter"
		And I press "Save"
		Then I should see "Electricity reading was successfully created"
		And I should see "2342"
		And I should see "13/11/2010"
		And I should see "19/11/2010"
		And I should see "rover"

	Scenario: edit electrical reading
		Given I have a meter with source type "Electrical Readings"
		And I have an electricity reading
		When I am logged in
		And I go to electricity readings
		Then I should see "4123.0"
		And I should see "01/02/2010"
		And I should see "jackson"
		And I follow "Edit"
		And I fill in "electricity_reading_electricity_value" with "1111"
		And I fill in "electricity_reading_start_time" with "14/11/2010"
		And I fill in "electricity_reading_end_time" with "18/11/2010"
		And I select "barefield" from "electricity_reading_meter"
		And I press "Save"
		Then I should see "Electricity reading was successfully updated."
		And I should see "1111"
		And I should see "14/11/2010"
		And I should see "18/11/2010"
		And I should see "jackson"
		