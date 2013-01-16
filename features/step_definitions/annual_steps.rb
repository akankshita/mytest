
Given /^I have a populated annual report$/ do
  deadline_date = Date.civil(2011, 7, 31)
  scheme_provider = SchemeProvider.create(:name => "CEMARS")
  annual_report = AnnualReport.create :deadline => deadline_date, :title => "Annual Report Phase One", :more_info => "<Placeholder for more info>", :phase => 1
  footprint_report = FootprintReport.create :deadline => deadline_date, :title => "Footprint Report Phase One", :more_info => "<Placeholder for more info>", :phase => 1 
  cca_task = CcaExemptionsTask.create(:footprint_report_id => footprint_report.id, :deadline => deadline_date, :more_info => "<Placeholder for more info>", :status => 0)
  renewables_task = RenewableTask.create :annual_report_id => annual_report.id, :deadline => deadline_date, :more_info => "<Placeholder for more info>", :status => 0  
  renewables = Renewable.create :roc => 0.0, :fit => 0.0, :renewablesGenerated => 0.0, :renewable_task_id => renewables_task.id
  confirm_energy_supply_task = ConfirmEnergySupplyTask.create :annual_report_id => annual_report.id, :is_confirmed => false, :more_info => "Confirm that you have uploaded all core electricity and gas usage data for the period of this report.", :status => 0  
  generating_electricity_credits_task = ElectricityGeneratingCreditsTask.create :annual_report_id => annual_report.id, :more_info => "Report how many credits you have received due to generating electricity.", :status => 0, :credits => 0  
  report_other_fuels_task = ReportOtherFuelsTask.create :annual_report_id => annual_report.id, :more_info => "Enter the data for all other fuels that have been used during the reporting year", :status => 0, :non_core_electricity => 0.0,       :non_core_gas => 0.0,       :aviation_spirit => 0.0, :blast_furnace_gas => 0.0,      :burning_fuels => 0.0,       :coke_oven_gas => 0.0,      :colliery_methane => 0.0,       :diesel => 0.0,       :fuel_oil=> 0.0,       :gas_oil => 0.0,       :industrial_coal=> 0.0,       :LPG => 0.0,       :lubricants =>0.0,       :waste => 0.0,       :naphtha => 0.0,      :natural_gas => 0.0,       :petrol_gas => 0.0,       :petrol =>0.0
  significant_group_undertakings_task = SignificantGroupUndertakingsTask.create :annual_report_id => annual_report.id, :more_info => "This section deals with reporting for any significant group undertakings for which you are the primary member.  A significant group undertaking is a collection of subsidaries in which any individual subsidary would qualify for the scheme in its own right", :status => 0
  early_action_metric_task = EarlyActionMetricTask.create(:annual_report_id => annual_report.id, :status => 0, :more_info => "This section deals with outlining what steps you have already taken to reduce your carbon emissions", :coverage => 0, :voluntary_amr => 0)
  growth_metrics = GrowthMetricTask.create(:annual_report_id => annual_report.id, :turnover => 0, :status => 0, :more_info => "This section deals with reporting your turnover for private organisations and revenue expenditure for public organisations.")
  disclosure_task = DisclosureTask.create :annual_report_id => annual_report.id, :question_1 => 2, :question_2 => 2, :question_3 => 2, :question_4 => 2, :more_info => "In this section you have to answer some optional questions relating to actions your organisation has taken regarding carbon emissions reduction.", :status => 0  
  disclosure_task.save
  growth_metrics.save
  early_action_metric_task.save
  significant_group_undertakings_task.save
  report_other_fuels_task.save
  renewables.save
  generating_electricity_credits_task.save
  confirm_energy_supply_task.save
  renewables_task.save
  footprint_report.save
  annual_report.save
  cca_task.save
  scheme_provider.save
end

Given /^I have one significant group undertakings$/ do
  significant_group_undertakings_task = SignificantGroupUndertakingsTask.first
  significant_group_undertaking = SignificantGroupUndertaking.create :significant_group_undertakings_task_id => significant_group_undertakings_task.id, :name => "acme", :carbon_emitted => 123.3
  significant_group_undertaking.save
  significant_group_undertakings_task.save
end


Then /^I should have a confirmed energy supply$/ do
  if(!AnnualReport.first.confirm_energy_supply_task.is_confirmed)
    raise Exception.new("confirm energy supply task was not set to true")
  end
end

Then /^I should have a confirmed energy supply with ongoing status$/ do
  if(!AnnualReport.first.confirm_energy_supply_task.status == 1)
    raise Exception.new("confirm energy supply task status was not set to on going")
  end
end

Then /^I should have a electricity generating credits task with (\d+) credits$/ do |credits|
  if(!AnnualReport.first.electricity_generating_credits_task.credits == credits.to_i)
    raise Exception.new("credits were not recorded in electricity generating credits task")
  end
end

Then /^I should see a fully populated report other fuels task on my annual report$/ do
  if(!AnnualReport.first.report_other_fuels_task.diesel == 3.0)
    raise Exception.new("Diesel value not recorded")
  end
  if(!AnnualReport.first.report_other_fuels_task.gas_oil == 1.5)
    raise Exception.new("Gas oil value not recorded")
  end
  if(!AnnualReport.first.report_other_fuels_task.petrol == 42)
    raise Exception.new("Petrol value not recorded")
  end
end

Then /^I should have a on\-going report other fuels$/ do
  if(!AnnualReport.first.report_other_fuels_task.status == 1)
    raise Exception.new("report other fuels status failed")
  end
end

Then /^I should have a significant group undertaking attached to my annual report with name "([^"]*)" and carbon emitted "([^"]*)"$/ do |name, carbon_emitted|
  if(!AnnualReport.first.significant_group_undertakings_task.significant_group_undertakings.first.name == name)
    raise Exception.new("name was not recorded")
  end
  if(!AnnualReport.first.significant_group_undertakings_task.significant_group_undertakings.first.carbon_emitted == carbon_emitted.to_f)
    raise Exception.new("carbon emitted was not recorded")
  end
end

When /^I should have no significant group undertakings associated with my annual report$/ do
  if(!AnnualReport.first.significant_group_undertakings_task.significant_group_undertakings.size == 0)
     raise Exception.new("delete failed")
  end
end

Then /^I should have a on\-going report significant group undertakings$/ do
  if(!AnnualReport.first.significant_group_undertakings_task.status == 1)
     raise Exception.new("status not set")
  end
end

Then /^I should have an early action metric with 55 percent in cemars and 44 amr$/ do
  if(!AnnualReport.first.early_action_metric_task.coverage == 55)
    raise Exception.new("coverage not set")
  end
  if(!AnnualReport.first.early_action_metric_task.voluntary_amr == 44)
    raise Exception.new("volantary amr not set")
  end
  if(!AnnualReport.first.early_action_metric_task.scheme_provider.name == "CEMARS")
    raise Exception.new("scheme provider not set")
  end
end

Then /^I should have an early action metric with completed status\.$/ do
  if(!AnnualReport.first.early_action_metric_task.status == 2)
    raise Exception.new("status not set")
  end
end

Then /^I should see a fully populated growth metric task with (\d+) turnover$/ do |turnover|
  if(!AnnualReport.first.growth_metric_task.turnover == turnover.to_f)
    raise Exception.new("turnover not set")
  end
end

Then /^I should have a on\-going growth metric$/ do
  if(!AnnualReport.first.growth_metric_task.status == 1)
    raise Exception.new("status not set")
  end
end

Then /^I should see a fully populated disclosure task on my annual report$/ do
  if(!AnnualReport.first.disclosure_task.question_1 == 0)
    raise Exception.new("question 1 not set")
  end
  if(!AnnualReport.first.disclosure_task.question_2 == 1)
    raise Exception.new("question 2 not set")
  end
  if(!AnnualReport.first.disclosure_task.question_3 == 2)
    raise Exception.new("question 3 not set")
  end
  if(!AnnualReport.first.disclosure_task.question_4 == 3)
    raise Exception.new("question 4 not set")
  end
end

Then /^I should have a on\-going disclosure task$/ do
  if(!AnnualReport.first.disclosure_task.status == 1)
    raise Exception.new("status not set")
  end
end

Then /^I should see a fully populated renewables with roc (\d+) and fit (\d+) and generated (\d+)$/ do |roc, fit, gen|
  renewable = AnnualReport.first.renewable_task.renewables.first

  assert_false("renewables not saved"){renewable.nil?}
  assert_true("roc not set"){renewable.roc == Integer(roc)}
  assert_true("fit not set"){renewable.fit == Integer(fit)}
  assert_true("gen not set"){renewable.renewablesGenerated == Integer(gen)}

end

Then /^I should see a completed renewables task$/ do
  assert_true("status not set"){AnnualReport.first.renewable_task.status == 2}
end
