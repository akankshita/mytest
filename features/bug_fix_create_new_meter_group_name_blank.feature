Feature: Bug fix meter create new meter group name blank
	In order to create new meter groups in the configure meters page
	As an user
	I want to be able to fill out a new meter group details and see it created and have name required

	Scenario: Creating new meter group
		Given I have a location 
		When I am logged in 
		And I go to source manager
		And I fill in "meter_group_name" with "barefield"
		And I press "meter_group_submit"
		Then I should have a meter group called "barefield"

    Scenario: Creating new meter group with no name creates error
        Given I have a location
        When I am logged in
        And I go to source manager
        And I press "meter_group_submit"
        Then I should see "1 error prohibited this meter group from being saved"