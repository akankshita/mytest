Feature: bug fix configure meters create location with no name error
	In order to handle a location being created without a name filled out
	As an user
	I want to click create location on with no name filled in and be presented with a page to enter the name

	Scenario: when clicking create location with no name, region appears correctly formatted
		Given I have a location
        When I am logged in
		And I go to source manager
        And I press "location_submit"
        Then I should see "Name can't be blank"
        And I should see "Region: Clare"

	Scenario: pressing back on the new location page should return you to the configure meters page
        Given I have a location
        When I am logged in
        And I go to source manager
        And I press "location_submit"
        Then I should see "Name can't be blank"
        And I should see "Region: Clare"
        When I follow "back"
        Then I should see "Source Manager"