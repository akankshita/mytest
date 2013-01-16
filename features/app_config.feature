Feature: user login
	In order to turn on or off some features
	As an user
	I want to go to app config page and turn features on and off

  Scenario: turn on gas
    Given I have an app config object with gas and crc turned off
    When I am logged in
    Then I should not see "Enter Gas Data"
    And I go to app config
    And I check "app_config_gas"
    And I press "Submit"
    Then I should see "Enter Gas Data"

   Scenario: turn on crc
     Given I have an app config object with gas and crc turned off
     When I am logged in
     Then I should not see "Reports"
     And I go to app config
     And I check "app_config_crc"
     And I press "Submit"
     Then I should see "Reports"
