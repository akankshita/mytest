Feature: Other fuels on footprint report
	In order to complete my footprint report
	As an user
	I want to be able to go to a page off the footprint report and list my other fuels

	Scenario: Add other fuel
      Given I have a populated footprint report
      When I am logged in
      And I go to the footprint report
      And I follow "Other Fuels"
      And I follow "Add Other Fuel"
      And I fill in "other_fuel_description" with "Gwan Munster"
      And I fill in "other_fuel_amount" with "2006"
      And I select "tonnes" from "other_fuel_unit"
      And I press "Create"
      Then I should see "Other Fuel was successfully created."
      And I should have an other fuel with description "Gwan Munster" and amount "2006" and unit "tonnes"

    Scenario: edit other fuel
      Given I have a populated footprint report
      When I am logged in
      And I go to the footprint report
      And I follow "Other Fuels"
      And I follow "Add Other Fuel"
      And I fill in "other_fuel_description" with "Gwan Munster"
      And I fill in "other_fuel_amount" with "2006"
      And I select "tonnes" from "other_fuel_unit"
      And I press "Create"
      And I follow "edit"
      And I fill in "other_fuel_description" with "Up the banner"
      And I fill in "other_fuel_amount" with "1995"
      And I press "Update"
      Then I should see "Other Fuel was successfully updated."
      And I should have an other fuel with description "Up the banner" and amount "1995" and unit "tonnes"

    Scenario: Add other fuel with no data
      Given I have a populated footprint report
      When I am logged in
      And I go to the footprint report
      And I follow "Other Fuels"
      And I follow "Add Other Fuel"
      And I fill in "other_fuel_description" with ""
      And I fill in "other_fuel_amount" with ""
      And I press "Create"
      Then I should see "3 errors"

    Scenario: Add other fuel with bad data
      Given I have a populated footprint report
      When I am logged in
      And I go to the footprint report
      And I follow "Other Fuels"
      And I follow "Add Other Fuel"
      And I fill in "other_fuel_amount" with "asdfasdf32342#$@^&*&^%$"
      And I press "Create"
      Then I should see "2 errors"

    Scenario: Remove other fuel
      Given I have a populated footprint report
      When I am logged in
      And I go to the footprint report
      And I follow "Other Fuels"
      And I follow "Add Other Fuel"
      And I fill in "other_fuel_description" with "Gwan Munster"
      And I fill in "other_fuel_amount" with "2006"
      And I select "tonnes" from "other_fuel_unit"
      And I press "Create"
      And I follow "Back"
      And I follow "Delete"
      Then I should have no other fuels

    Scenario: Change status of other fuel
      Given I have a populated footprint report
      When I am logged in
      And I go to the footprint report
      And I follow "Other Fuels"
      And I choose "task_status_2"
      And I press "Save"
      Then I should see "Other fuels task status was successfully changed."
      And I should have a completed other fuels task