Feature: document uploads
	In order to store documents relating to emission activities
	As an user
	I want to be upload documents of different types and click links on graphs showing which docs support data
	
	Scenario: upload a document of gas bill type
		Given I have a "gas bill" document type with source type: "Gas Readings"
		When I am logged in 
		And I go to upload documents
		And I follow "Upload Document"
		And I attach the file "tmp/test.pdf" to "document_upload_uploaded_data"
		And I select "gas bill" from "document_upload_document_type"
		And I fill in "13/04/2010" for "document_upload_start_date"
		And I fill in "14/04/2010" for "document_upload_end_date"
		And I fill in "April bill" for "document_upload_name"
		And I press "Save"
		Then I should see "Document was successfully uploaded."
		And I should have a upload document with filename: "test.pdf", doc type: "gas bill", start time: "13/4/2010", end_date: ,"14/4/2010", name: "April Bill"
	
	Scenario: edit a document of gas bill type
		Given I have a "gas bill" document type with source type: "Gas Readings"
		When I am logged in
		And I have a "electricity bill" document type with source type: "Electrical Readings"
		And I have a document uploaded with filename: "test.pdf", doc type: "gas bill", start time: "13/4/2010", end_date: ,"14/04/2010", name: "June Bill"
		When I go to upload documents
		And I follow "Edit"
		And I select "electricity bill" from "document_upload_document_type"
		And I fill in "14/05/2010" for "document_upload_start_date"
		And I fill in "15/05/2010" for "document_upload_end_date"
		And I fill in "July Bill" for "document_upload_name"
		And I press "Save"
		Then I should see "Document was successfully edited."
		And I should have a upload document with filename: "test.pdf", doc type: "electricity bill", start time: "14/5/2010", end_date: ,"15/05/2010", name: "July Bill"
			
	Scenario: follow link to provide doc details when docs available for timespan
		Given I have a "gas bill" document type with source type: "Gas Readings"
		When I am logged in
		And I have a document uploaded with filename: "test.pdf", doc type: "gas bill", start time: "13/04/2010", end_date: ,"20/04/2010", name: "July Bill"
		When I follow doc upload timespan link with source type: "Gas%20Readings", date: ,"19/04/2010" 
		And I should see "gas bill"
		And I should see "13/04/2010"
		And I should see "20/04/2010"
		And I should see "July Bill"
	
	Scenario: follow link to provide doc details when docs available for exact timespan
		Given I have a "gas bill" document type with source type: "Gas Readings"
		When I am logged in
		Given I have a document uploaded with filename: "test.pdf", doc type: "gas bill", start time: "13/04/2010", end_date: ,"20/04/2010", name: "July Bill"
		When I follow doc upload timespan link with source type: "Gas%20Readings", date: ,"19/04/2010" 
		And I should see "gas bill"
		And I should see "13/04/2010"
		And I should see "20/04/2010"
		And I should see "July Bill"
		
	Scenario: Follow link to provide doc details when no docs available for timespan
		Given I have a "gas bill" document type with source type: "Gas Readings"
		When I am logged in
		And I have a document uploaded with filename: "test.pdf", doc type: "gas bill", start time: "13/04/2010", end_date: ,"20/04/2010", name: "July Bill"
		When I follow doc upload timespan link with source type: "Gas%20Readings", date: ,"20/05/2010" 
		Then I should see "No documents uploaded for this time and document type"
	
	Scenario: Follow list link when not logged in doesn't allow access
		When I follow doc upload timespan link with source type: "Gas%20Readings", date: ,"20/05/2010"
		Then I should see "Please Login"
	
	Scenario: Delete document
		Given I have a "gas bill" document type with source type: "Gas Readings"
		When I am logged in
		And I have a "electricity bill" document type with source type: "Electrical Readings"
		And I have a document uploaded with filename: "test.pdf", doc type: "gas bill", start time: "13/4/2010", end_date: ,"14/04/2010", name: "June Bill"
		When I go to upload documents
		And I follow "Delete"
		Then I should see "Document was successfully deleted."
		And I should have no upload documents