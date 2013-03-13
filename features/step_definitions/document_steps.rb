Given /^I have a "([^"]*)" document type with source type: "([^"]*)"$/ do |document_type_name, source_type_name|
  source_type = SourceType.create(:name => source_type_name)
  source_type.save

  document_type = DocumentType.create(:name => document_type_name, :source_type => source_type)
  document_type.save
end

Then /^I should have a upload document with filename: "([^"]*)", doc type: "([^"]*)", start time: "([^"]*)", end_date: ,"([^"]*)", name: "([^"]*)"$/ do |arg1, arg2, arg3, arg4, arg5|
  document_type = DocumentType.first
  assert_true("document was not created") { !document_type.nil? }
  
end

Given /^I have a document uploaded with filename: "([^"]*)", doc type: "([^"]*)", start time: "([^"]*)", end_date: ,"([^"]*)", name: "([^"]*)"$/ do |filename, document_type_name, start_date, end_date, name|
  document_type = DocumentType.first(:conditions => "name = '#{document_type_name}'")
  start_date =  TimeUtils.parse_european_date(start_date)
  end_date =  TimeUtils.parse_european_date(end_date)
  document_upload = DocumentUpload.create(:document_type => document_type, :user => User.first, :filename => filename, :start_date => start_date, :end_date => end_date, :name => name)
  
  assert_saved(document_upload)
end

When /^I follow doc upload timespan link with source type: "([^"]*)", date: ,"([^"]*)"$/ do |source_type, date|
  date_object = TimeUtils.parse_european_date(date)
  javascript_timestamp = date_object.to_time.to_i.to_s + "000"
  url = "document_uploads/list?date=#{javascript_timestamp}&source_type=#{source_type}"
  visit url
end


Then /^I should have no upload documents$/ do
  assert_true("document was not delete") { DocumentUpload.all.size == 0 }
end




