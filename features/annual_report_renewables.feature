Feature: 
	In order to complete my annual report
	As an user
	I want to be able to go to a page off the annual report and report how much other fuels I've used in the past year

	Scenario: "Go to other fuels page and fill in data"
		Given I have a populated annual report
		When I am logged in
		And I go to the Annual Report
		And I follow "Renewables"
		And I fill in "renewable_roc" with "2342"
		And I fill in "renewable_fit" with "15"
		And I fill in "renewable_renewablesGenerated" with "42"
		And I press "Update"
		Then I should see "Renewable was successfully updated."
		And I should see a fully populated renewables with roc 2342 and fit 15 and generated 42

	Scenario: Change status of report other fuels
        Given I have a populated annual report
		When I am logged in
		And I go to the Annual Report
		And I follow "Renewables"
		And I choose "task_status_2"
		And I press "Update"
		Then I should see "Renewable was successfully updated."
		And I should see a completed renewables task