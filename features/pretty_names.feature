Feature: 
	In order to see good names on each page
	As an user
	I want to be page names to come from a database
	
	Scenario: Login and view gas totals
	Given I have a controller display name for "Gas Totals"
	When I am logged in
	And I go to gas totals
	Then I should see "Gas Totals" within "#title_name"
	