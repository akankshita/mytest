Feature: Residual emissions on footprint report
	In order to complete my footprint report
	As an user
	I want to be able to go to a page off the footprint report and list my residual emissions

	Scenario: Add residual emission
      Given I have a populated footprint report
      When I am logged in
      And I go to the footprint report
      And I follow "Residual Emissions"
      And I follow "New residual emission"
      And I select "waste_solvents" from "residual_emission_fuel_list"
      And I fill in "residual_emission_tonnes_c02" with "55555"
      And I press "Create"
      Then I should see "Residual Emission was successfully created."
      And I should have a residual emission with fuel "waste_solvents" and co2 "55555"

    Scenario: edit cca exemption
      Given I have a populated footprint report
      When I am logged in
		And I go to the footprint report
		And I follow "Residual Emissions"
        And I follow "New residual emission"
        And I select "waste_solvents" from "residual_emission_fuel_list"
        And I fill in "residual_emission_tonnes_c02" with "55555"
		And I press "Create"
        And I follow "edit"
        And I fill in "residual_emission_tonnes_c02" with "44444"
	    And I press "Update"
      Then I should see "ResidualEmission was successfully updated."
          And I should have a residual emission with fuel "waste_solvents" and co2 "44444"

    Scenario: Add cca exemption with no data
      Given I have a populated footprint report
      When I am logged in
      And I go to the footprint report
      And I follow "Residual Emissions"
      And I follow "New residual emission"
      And I select "waste_solvents" from "residual_emission_fuel_list"
      And I press "Create"
      Then I should see "2 errors"

    Scenario: Add cca exemption with bad data
      Given I have a populated footprint report
      When I am logged in
      And I go to the footprint report
      And I follow "Residual Emissions"
      And I follow "New residual emission"
      And I select "waste_solvents" from "residual_emission_fuel_list"
      And I fill in "residual_emission_tonnes_c02" with "abc"
      And I press "Create"
      Then I should see "1 error"

    Scenario: Remove cca exemption
      Given I have a populated footprint report
      When I am logged in
      And I go to the footprint report
      And I follow "Residual Emissions"
      And I follow "New residual emission"
      And I select "waste_solvents" from "residual_emission_fuel_list"
      And I fill in "residual_emission_tonnes_c02" with "55555"
      And I press "Create"
      And I follow "Back"
      And I follow "Delete"
      Then I should have no residual emissions

	Scenario: Change status of cca exemption
      Given I have a populated footprint report
      When I am logged in
      And I go to the footprint report
      And I follow "Residual Emissions"
      And I choose "task_status_2"
	  And I press "Save"
      Then I should see "Residual emissions task status was successfully changed."
	  And I should have a complete residual emissions task
