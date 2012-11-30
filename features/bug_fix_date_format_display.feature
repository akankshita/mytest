Feature: Bug fix Date and times are displayed correctly in uk format
	In order to easily view and under stand dates
	As an user
	I want to be able to see all dates in the correct format across the site
	
	Scenario: Dates rendering correctly on the gas readings page
		Given I have meter group called floor_4 and meter called gas_meter which are siblings
		And I have gas data for meter group floor_4 and meter gas_meter
		When I am logged in 
		And I go to gas readings
		Then I should see the correctly formated end date
		