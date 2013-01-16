Feature: reconfirm cca exemptions on footprint report
	In order to complete my footprint report
	As an user
	I want to be able to go to a page off the footprint report and reconfirm my cca exemptions

	Scenario: reconfirm cca exemption
	  Given I have a populated footprint report
      When I am logged in
		And I go to the footprint report
		And I follow "re-confirm CCA exemptions"
        And I choose "choice_3"
		And I press "Submit"
      Then I should see "successfully reconfirmed CCA exemptions."
		And I should have a reconfirmed cca exemption with value "3"

    Scenario: change reconfirm cca exemptions task
      Given I have a populated footprint report
      When I am logged in
        And I go to the footprint report
        And I follow "re-confirm CCA exemptions"
        And I choose "task_status_0"
        And I press "submit"
      Then I should see "successfully reconfirmed CCA exemptions."
        And I should have a reconfirmed cca exemption task with incomplete status
