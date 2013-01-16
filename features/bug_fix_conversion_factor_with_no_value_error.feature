Feature: bug fix conversion factor with no value error
	In order to ensure all new conversion factors have a value
	As an user
	I want to see the correct errors when creating a factor with no value

	Scenario: create a valid conversion factor
        Given I have both source types
        When I am logged in
		And I go to conversion factor
        And I follow "New Conversion Factor"
        And I fill in "conversion_factor_rate" with "123456"
        And I press "create"
        Then I should see "123456"

	Scenario: create an invalid conversion factor
      Given I have both source types
      When I am logged in
      And I go to conversion factor
      And I follow "New Conversion Factor"
      And I press "create"
      Then I should see "2 errors prohibited this conversion factor from being saved"