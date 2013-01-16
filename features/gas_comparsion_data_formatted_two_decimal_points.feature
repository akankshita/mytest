Feature: gas comparison data formatting
  In order to improve comparison graphs readability
  As an user
  I want to have all data rounded to two decimal points

  Scenario: Data is correctly formatted
    Given I am logged in
    And I have meter group called Clare and meter called Barefield which are siblings
    And I have gas data for meter group "Clare" and meter "Barefield"
    When I go to gas comparison page
    Then I should see data with two decimal points