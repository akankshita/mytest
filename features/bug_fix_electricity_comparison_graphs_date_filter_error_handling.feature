Feature: Bug fix electricity comparison graphs date filter error handling
  In order to not see and stack traces on the electricity comparison pages
  As an user
  I want to be able to enter any type of input into the date fields without seeing errors

  Scenario: Navigate to comparison page without any data
    Given I am logged in
    When I go to electricity comparison page
    Then I should see "Electricity Comparisons"

  Scenario: Only enter start date
    Given I am logged in
    And I have meter group called Clare and meter called Barefield which are siblings
    And I have electricity data for meter group "Clare" and meter "Barefield"
    When I go to electricity comparison page
    And I fill in "selected_start_date" with "06/04/1983"
    And I press "filter"
    Then I should see "If you enter either a start or end date you must enter both."

  Scenario: Only enter end date
    Given I am logged in
    And I have electricity data for meter group "Clare" and meter "Barefield"
    And I have meter group called Clare and meter called Barefield which are siblings
    When I go to electricity comparison page
    And I fill in "selected_end_date" with "06/04/1983"
    And I press "filter"
    Then I should see "If you enter either a start or end date you must enter both."

  Scenario: Enter same start date and end date
    Given I am logged in
    And I have meter group called Clare and meter called Barefield which are siblings
    And I have electricity data for meter group "Clare" and meter "Barefield"
    When I go to electricity comparison page
    And I fill in "selected_start_date" with "06/04/1983"
    And I fill in "selected_end_date" with "06/04/1983"
    And I press "filter"
    Then I should see "Gas Comparisons"

  Scenario: Enter start date after end date
    Given I am logged in
    And I have meter group called Clare and meter called Barefield which are siblings
    And I have electricity data for meter group "Clare" and meter "Barefield"
    When I go to electricity comparison page
    And I fill in "selected_start_date" with "20/04/1999"
    And I fill in "selected_end_date" with "06/04/1983"
    And I press "filter"
    Then I should see "End date must be after start date."

  Scenario: Empty start date and end date
    Given I am logged in
    And I have meter group called Clare and meter called Barefield which are siblings
    And I have electricity data for meter group "Clare" and meter "Barefield"
    When I go to electricity comparison page
    And I fill in "selected_start_date" with ""
    And I fill in "selected_end_date" with ""
    And I press "filter"
    Then I should see "You need to enter a start and end date."

  Scenario: bad text in start date
    Given I am logged in
    And I have meter group called Clare and meter called Barefield which are siblings
    And I have electricity data for meter group "Clare" and meter "Barefield"
    When I go to electricity comparison page
    And I fill in "selected_start_date" with "asdf"
    And I press "filter"
    Then I should see "If you enter either a start or end date you must enter both."
    Then I should see "Start date is incorrectly formatted. Format is dd/mm/yyyy."

  Scenario: bad text in end date
    Given I am logged in
    And I have meter group called Clare and meter called Barefield which are siblings
    And I have electricity data for meter group "Clare" and meter "Barefield"
    When I go to electricity comparison page
    And I fill in "selected_end_date" with "asdf"
    And I press "filter"
    Then I should see "If you enter either a start or end date you must enter both."
    Then I should see "End date is incorrectly formatted. Format is dd/mm/yyyy."