Feature: electricity upload files input error handling
	In order to handle errors while uploading electricity files
	As an user
	I want to be able to see the errors correctly displayed and handled

	Scenario: enter nothing on electricity upload page and hit submit
      Given I have a "electricity bill" document type with source type: "Electrical Readings"
      When I am logged in
      And I go to upload electricity file
      And I follow "Upload Electrical Data File"
      And I press "Upload"
      Then I should see "4 errors prohibited this electricity upload from being saved"

    Scenario: enter letters symbols into interval
      Given I have a "electricity bill" document type with source type: "Electrical Readings"
      When I am logged in
      And I go to upload electricity file
      And I follow "Upload Electrical Data File"
      And I fill in "electricity_upload_interval" with "asdfasdfasdf%#$%#@"
      And I press "Upload"
      Then I should see "3 errors prohibited this electricity upload from being saved"
