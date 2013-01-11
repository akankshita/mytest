Feature: gas upload files input error handling
	In order to handle errors while uploading gas files
	As an user
	I want to be able to see the errors correctly displayed and handled

	Scenario: enter nothing on gas upload page and hit submit
      Given I have a "gas bill" document type with source type: "Gas Readings"
      When I am logged in
      And I go to upload gas file
      And I follow "Upload Gas Data File"
      And I press "Create"
      Then I should see "4 errors prohibited this gas upload from being saved"

    Scenario: enter letters symbols into interval
      Given I have a "gas bill" document type with source type: "Gas Readings"
      When I am logged in
      And I go to upload gas file
      And I follow "Upload Gas Data File"
      And I fill in "gas_upload_interval" with "asdfasdfasdf%#$%#@"
      And I press "Create"
      Then I should see "3 errors prohibited this gas upload from being saved"
