Feature: 
	In order to complete my annual report
	As an user
	I want to be able to go to a page off the annual report and report my growth metric data
	
	Scenario: "Go to growth metric page and fill in data"
		Given I have a populated annual report
		When I am logged in
		And I go to the Annual Report
		And I follow "Growth Metric"
		And I fill in "growth_metric_task_turnover" with "45000"
		And I press "Save"
		Then I should see "Growth metric data was successfully updated."
		And I should see a fully populated growth metric task with 45000 turnover
	
	Scenario: Change status of growth metric data
		Given I have a populated annual report
		When I am logged in
		And I go to the Annual Report
		And I follow "Growth Metric"
		And I choose "task_status_1"
        And I press "Save"
		Then I should see "Growth metric data was successfully updated."
		And I should have a on-going growth metric