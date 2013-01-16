Feature: electricity reading meter on show page
	In order to see what reading a meter belongs to
	As an user
	I want to be able to go to the electricity reading show page and see the meter it belongs to
	
	Scenario: Go to electricity reading show page and see meter
		Given I have a meter with source type "Electrical Readings"
		And I have an electricity reading
		When I am logged in
		And I go to electricity readings
		Then I should see "4123.0"
		And I should see "01/02/2010"
		And I should see "jackson"
		And I follow "Show"
		Then I should see "barefield"
		
