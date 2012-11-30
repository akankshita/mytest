Feature: 
	In order to complete my annual report
	As an user
	I want to be able to go to a page off the annual report and answer the additional disclosure of information questions
	
	Scenario: "Go to disclosure page and fill in data"
		Given I have a populated annual report
		When I am logged in
		And I go to the Annual Report
		And I follow "Disclosure of information"
		And I choose "disclosure_task_question_1_0"
		And I choose "disclosure_task_question_2_1"
		And I choose "disclosure_task_question_3_2"
		And I choose "disclosure_task_question_4_0"
		And I press "Save"
		Then I should see "Additional disclosure information was successfully saved."
		And I should see a fully populated disclosure task on my annual report
	
	Scenario: Change status of disclosure task
		Given I have a populated annual report
		When I am logged in
		And I go to the Annual Report
		And I follow "Disclosure of information"
		And I choose "task_status_1"
        And I press "Save"
		Then I should see "Additional disclosure information was successfully saved."
		And I should have a on-going disclosure task