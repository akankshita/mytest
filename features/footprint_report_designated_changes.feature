Feature: designated changes on footprint report
	In order to complete my footprint report
	As an user
	I want to be able to go to a page off the footprint report and report any designated changes

	Scenario: Confirm designated change
		Given I have a populated footprint report
		When I am logged in
		And I go to the footprint report
		And I follow "Designated Change"
        And I fill in "designated_change_date_of_change" with "2011-05-11"
        And I fill in "designated_change_text" with "up the banner"
		And I press "Save"
		Then I should see "designated changes were successfully updated."
		And I should have a designated change with date "2011-05-11" and text "up the banner"

	Scenario: Change status of designated changes
		Given I have a populated footprint report
		When I am logged in
		And I go to the footprint report
		And I follow "Designated Change"
        And I fill in "designated_change_date_of_change" with "2011-05-11"
        And I fill in "designated_change_text" with "up the banner"
        And I choose "task_status_1"
		And I press "Save"
		Then I should see "designated changes were successfully updated."
		And I should have a designated change with date "2011-05-11" and text "up the banner"
        And I should have a designated change with on-going status