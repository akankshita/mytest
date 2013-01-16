Feature: 
	In order to complete my annual report
	As an user
	I want to be able to go to a page off the annual report and report on early action metrics

	Scenario: Report early action metrics
		Given I have a populated annual report
		When I am logged in
		And I go to the Annual Report
		And I follow "Early Action metrics" 
		And I fill in "early_action_metric_task_coverage" with "55"
		And I fill in "early_action_metric_task_voluntary_amr" with "44"
		And I select "CEMARS" from "early_action_metric_task_scheme_provider"
		And I press "Save"
		Then I should see "Early action metric was successfully saved."
		And I should have an early action metric with 55 percent in cemars and 44 amr

 	Scenario: Change status of early action metric
		Given I have a populated annual report
		When I am logged in
		And I go to the Annual Report
		And I follow "Early Action Metrics"
        And I choose "task_status_2"
        And I press "Save"
		Then I should see "Early action metric was successfully saved."
		And I should have an early action metric with completed status.