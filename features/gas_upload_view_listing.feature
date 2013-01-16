Feature: gas upload files view all files 
	In order to what files have been uploaded with gas readings 
	As an user
	I want to be able to see a page that details all gas reading uploaded files
	
	Scenario: view all uploaded gas files
		Given I have a gas upload file 
		When I am logged in 
		And I go to upload gas file
		Then I should see "test"