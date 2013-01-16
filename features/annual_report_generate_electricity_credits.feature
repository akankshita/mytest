Feature: 
	In order to complete my annual report
	As an user
	I want to be able to go to a page off the annual report and report how much electricity credits I have generated
	
	Scenario: Confirm electricity generating credits complete
		Given I have a populated annual report
		When I am logged in
		And I go to the Annual Report
		And I follow "Electricity Generating Credits" 
		And I fill in "credits" with "30"
		And I press "Confirm"
		Then I should see "Electricity generating credits successfully reported"
		And I should have a electricity generating credits task with 30 credits

	Scenario: Change status of electricity generating credits
		Given I have a populated annual report
		When I am logged in
		And I go to the Annual Report
		And I follow "Electricity Generating Credits"
		And I choose "task_status_2"
        And I press "confirm"
		Then I should see "Electricity generating credits successfully reported"
		And I should have a confirmed energy supply with ongoing status