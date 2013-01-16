Feature: electricity comparison date filtering
  In order to see comparison graphs for certain date spans
  As an user
  I want to be able to enter a start and end date which limits the data presented in graphs

  Scenario: No filters applied with data
    Given I am logged in
    And I have meter group called Clare and meter called Barefield which are siblings
    And I have electricity data for meter group "Clare" and meter "Barefield"
    When I go to electricity comparison page
    Then I should see 1 months with data points

  Scenario: Filters applied with matching data
    Given I am logged in
    And I have meter group called Clare and meter called Barefield which are siblings
    And I have electricity data for meter group "Clare" and meter "Barefield"
    When I go to electricity comparison page
    And I fill in "selected_start_date" with "01/01/2010"
    And I fill in "selected_end_date" with "01/12/2010"
    And I press "filter"
    Then I should see 1 months with data points

  Scenario: Filters applied with no matching data
    Given I am logged in
    And I have electricity data for meter group "Clare" and meter "Barefield"
    When I go to electricity comparison page
    And I fill in "selected_start_date" with "01/01/2011"
    And I fill in "selected_end_date" with "01/12/2011"
    And I press "filter"
    Then I should see 0 months with data points