Feature: Bug fix meter group and meter id filtering with logical
	In order to create new meters in the configure meters page
	As an user
	I want to be able to fill out a new meters details and see it created
	
	Scenario: Creating new meter
		Given I have a location 
		When I am logged in 
		And I go to source manager
		And I fill in "meter_meter_identifier" with "abc123"
		And I select "Gas Readings" from "Source Type"
		And I fill in "meter_name" with "barefield meter"
		And I press "meter_submit"
		Then I should have a meter called "barefield meter" with identifier "abc123"

    Scenario: Creating new meter with no name creates error
        Given I have a location
        When I am logged in
        And I go to source manager
        And I press "meter_submit"
        Then I should see "3 errors prohibited this meter from being saved"