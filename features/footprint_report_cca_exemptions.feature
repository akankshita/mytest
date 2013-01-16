Feature: cca exemptions on footprint report
	In order to complete my footprint report
	As an user
	I want to be able to go to a page off the footprint report and list my cca exemptions

	Scenario: Add cca exemption
	  Given I have a populated footprint report
      When I am logged in
		And I go to the footprint report
		And I follow "CCA exemptions"
        And I follow "New cca exemption"
        And I fill in "cca_exemption_tui" with "abc123"
        And I fill in "cca_exemption_company_name" with "munster inc"
        And I fill in "cca_exemption_emissions_covered" with "20010"
		And I press "Save"
      Then I should see "A new CCA Exemption was successfully created."
		And I should have a cca exemption with tui "abc123" and name "munster inc" and emissions covered "20010"

    Scenario: edit cca exemption
	  Given I have a populated footprint report
      When I am logged in
		And I go to the footprint report
		And I follow "CCA exemptions"
        And I follow "New cca exemption"
        And I fill in "cca_exemption_tui" with "abc123"
        And I fill in "cca_exemption_company_name" with "munster inc"
        And I fill in "cca_exemption_emissions_covered" with "20010"
		And I press "Save"
        And I follow "edit"
        And I fill in "cca_exemption_tui" with "munster rugby"
        And I fill in "cca_exemption_company_name" with "paul o'connell"
        And I fill in "cca_exemption_emissions_covered" with "9999"
		And I press "Save"
      Then I should see "CCA Exemption was successfully updated."
		And I should have a cca exemption with tui "munster rugby" and name "paul o'connell" and emissions covered "9999"

    Scenario: Add cca exemption with no data
      Given I have a populated footprint report
      When I am logged in
		And I go to the footprint report
		And I follow "CCA exemptions"
        And I follow "New cca exemption"
		And I press "Save"
      Then I should see "4 errors prohibited this cca exemption from being saved"

    Scenario: Add cca exemption with bad data
      Given I have a populated footprint report
      When I am logged in
		And I go to the footprint report
		And I follow "CCA exemptions"
        And I follow "New cca exemption"
        And I fill in "cca_exemption_emissions_covered" with "asdfba445%$45%#(@cca_exemption.tui)20010"
		And I press "Save"
      Then I should see "3 errors prohibited this cca exemption from being saved"

    Scenario: Remove cca exemption
       Given I have a populated footprint report

      When I am logged in
		And I go to the footprint report
		And I follow "CCA exemptions"
        And I follow "New cca exemption"
        And I fill in "cca_exemption_tui" with "abc123"
        And I fill in "cca_exemption_company_name" with "munster inc"
        And I fill in "cca_exemption_emissions_covered" with "20010"
		And I press "Save"
      Then I should see "A new CCA Exemption was successfully created."
		And I should have a cca exemption with tui "abc123" and name "munster inc" and emissions covered "20010"
      When I follow "delete"
      Then I should see "CCA Exemption removed"

	Scenario: Change status of cca exemption
      Given I have a populated footprint report
      When I am logged in
		And I go to the footprint report
		And I follow "CCA exemptions"
        And I choose "task_status_2"
		And I press "Save"
      Then I should see "CCA Exemptions task status was successfully changed."
		And I should have a complete cca exemption
