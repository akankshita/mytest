Feature: 
	In order to complete my annual report
	As an user
	I want to be able to go to a page off the annual report and confirm I have uploaded my energy supply data

	Scenario: Confirm energy supply complete
		Given I have a populated annual report
		When I am logged in
		And I go to the Annual Report
		And I follow "Confirm Core Energy Supply" 
		And I choose "confirm_energy_supply_task_is_confirmed_true"
		And I press "Confirm"
		Then I should see "Energy supply successfully confirmed"
		And I should have a confirmed energy supply

	Scenario: Change status of confirmed annual report
		Given I have a populated annual report
		When I am logged in
		And I go to the Annual Report
		And I follow "Confirm Core Energy Supply"
		And I choose "task_status_2"
        And I press "confirm"
		Then I should see "Energy supply successfully confirmed"
		And I should have a confirmed energy supply with ongoing status 