Feature: 
	In order to complete my annual report
	As an user
	I want to be able to go to the annual report page and create a list of significant group undertakings with their related carbon emissions
	
	Scenario: "Go to significant group undertakings page and record a significant undertaking"
		Given I have a populated annual report
		When I am logged in
		And I go to the Annual Report
		And I follow "Significant group undertakings"
		And I follow "New significant group undertaking"
		And I fill in "significant_group_undertaking_name" with "Acme"
		And I fill in "significant_group_undertaking_carbon_emitted" with "1005.5"
		And I press "Save"
		Then I should see "Significant group undertaking was successfully recorded."
		And I should have a significant group undertaking attached to my annual report with name "Acme" and carbon emitted "1005.1"
		
	Scenario: "Go to significant group undertakings page and edit a significant undertaking"
		Given I have a populated annual report
		And I have one significant group undertakings
		When I am logged in
		And I go to the Annual Report
		And I follow "Significant group undertakings"
		And I follow "Edit"
		And I fill in "significant_group_undertaking_name" with "Acme 2"
		And I fill in "significant_group_undertaking_carbon_emitted" with "1002.5"
		And I press "Save"
		Then I should see "Significant group undertaking was successfully edited."
		And I should have a significant group undertaking attached to my annual report with name "Acme 2" and carbon emitted "1002.5"
		
	Scenario: "Go to significant group undertakings page and delete a significant undertaking"
		Given I have a populated annual report
		And I have one significant group undertakings
		When I am logged in
		And I go to the Annual Report
		And I follow "Significant group undertakings"
		And I follow "Delete"
		And I should have no significant group undertakings associated with my annual report

	Scenario: Change status of report significant group undertakings
		Given I have a populated annual report
		When I am logged in
		And I go to the Annual Report
		And I follow "Significant group undertakings"
		And I choose "task_status_1"
        And I press "Save"
		Then I should see "Significant group undertaking task status was successfully changed."
		And I should have a on-going report significant group undertakings