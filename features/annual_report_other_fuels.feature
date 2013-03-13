Feature: 
	In order to complete my annual report
	As an user
	I want to be able to go to a page off the annual report and report how much other fuels I've used in the past year
	
	Scenario: "Go to other fuels page and fill in data"
		Given I have a populated annual report
		When I am logged in
		And I go to the Annual Report
		And I follow "Report Other Fuels"
		And I fill in "diesel" with "3.0"
		And I fill in "gas oil" with "1.5"
		And I fill in "petrol" with "42"
		And I press "Save"
		Then I should see "Successfully saved other fuels used"
		And I should see a fully populated report other fuels task on my annual report

	Scenario: Change status of report other fuels
		Given I have a populated annual report
		When I am logged in
		And I go to the Annual Report
		And I follow "Report Other Fuels"
		And I choose "task_status_1"
        And I press "Save"
		Then I should see "Successfully saved other fuels used"
		And I should have a on-going report other fuels 