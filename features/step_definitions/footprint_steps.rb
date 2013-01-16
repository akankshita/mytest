Given /^I have a populated footprint report$/ do
  deadline_date = Date.civil(2011, 7, 31)
  footprint_report = FootprintReport.create :deadline => deadline_date, :title => "Footprint Report Phase One", :more_info => "<Placeholder for more info>", :phase => 1

  designated_changes_task = DesignatedChangesTask.create(:footprint_report_id => footprint_report.id, :deadline => deadline_date, :status => 0)
  footprint_report.designated_changes_task = designated_changes_task
  designated_change = DesignatedChange.create(:date_of_change => "2011-05-11", :text => "gwan munster")
  designated_changes_task.designated_changes.push(designated_change)

  cca_exemptions_task = CcaExemptionsTask.create(:footprint_report_id => footprint_report.id, :deadline => deadline_date, :more_info => "<Placeholder for more info>", :status => 0)

  reconfirmed_task = ReconfirmationExemptionTask.create(:footprint_report_id => footprint_report.id, :choice => 0, :status => 2)

  energy_supply_task = EnergyMetricsTask.create :footprint_report_id => footprint_report.id, :more_info => "<Placeholder for more info>", :status => 0, :core_electricity => 0.0, :core_gas => 0.0, :non_core_electricity => 0.0,       :non_core_gas => 0.0,       :aviation_spirit => 0.0, :blast_furnace_gas => 0.0,      :burning_fuels => 0.0,       :coke_oven_gas => 0.0,      :colliery_methane => 0.0,       :diesel => 0.0,       :fuel_oil=> 0.0,       :gas_oil => 0.0,       :industrial_coal=> 0.0,       :LPG => 0.0,       :lubricants =>0.0,       :waste => 0.0,       :naphtha => 0.0,      :natural_gas => 0.0,       :petrol_gas => 0.0,       :petrol =>0.0

  emission_task = EmissionMetricsTask.create :footprint_report_id => footprint_report.id, :more_info => "<Placeholder for more info>", :status => 0,  :core_energy_ETS => 0, :non_core_energy_ETS => 0, :cca_subsidiaries => 0,  :cca_core_energy => 0, :cca_non_core_energy => 0, :electricity_generated_credit => 0,  :renewables_generation => 0

  residual_task = ResidualEmissionsTask.create :footprint_report_id => footprint_report.id, :more_info => "<Placeholder for more info>", :status => 0

  fuel = FuelList.create(:fuel_name => "waste_solvents", :emission_factor_v1 => 1)

  other_fuel_task = OtherFuelsTask.create :footprint_report_id => footprint_report.id, :more_info => "<Placeholder for more info>", :status => 0

  unit = Unit.create(:name => "tonnes")

  assert_saved(unit)
  assert_saved(other_fuel_task)
  assert_saved(fuel)
  assert_saved(residual_task)
  assert_saved(emission_task)
  assert_saved(energy_supply_task)
  assert_saved(reconfirmed_task)
  assert_saved(cca_exemptions_task)
  assert_saved(designated_change)
  assert_saved(designated_changes_task)
  assert_saved(footprint_report)

end

Then /^I should have a designated change with date "([^"]*)" and text "([^"]*)"$/ do |date, text|
  designated_change = FootprintReport.first.designated_changes_task.designated_changes.first

  if(designated_change.nil?)
    raise Exception.new("designated change not saved")
  end
  if(!designated_change.date_of_change.to_s == date)
    raise Exception.new("designated change date of change not set")
  end
   if(!designated_change.text == text)
    raise Exception.new("designated change text not set")
  end
end

Then /^I should have a designated change with on\-going status$/ do
  designated_change = FootprintReport.first.designated_changes_task.designated_changes.first

  if(designated_change.designated_changes_task.status != 1)
    raise Exception.new("designated change task status not equal to on-going")
  end
end

Then /^I should have a cca exemption with tui "([^"]*)" and name "([^"]*)" and emissions covered "([^"]*)"$/ do |tui, name, emissions|
  cca_exemption = FootprintReport.first.cca_exemptions_task.cca_exemptions.first

  if(cca_exemption.nil?)
    raise Exception.new("cca exemption not saved")
  end
  if(cca_exemption.tui != tui)
    raise Exception.new("tui not saved")
  end
  if(cca_exemption.company_name != name)
    raise Exception.new("name not saved")
  end
  emissions_integer = Integer(emissions)
  if (cca_exemption.emissions_covered != emissions_integer)
    raise Exception.new("emissions not saved")
  end
end

Then /^I should have a complete cca exemption$/ do
   cca_exemptions_task = FootprintReport.first.cca_exemptions_task

  if(cca_exemptions_task.nil?)
    raise Exception.new("cca exemption task not saved")
  end
  if(cca_exemptions_task.status != 2)
    raise Exception.new("status not set to complete")
  end
end

Then /^I should have a reconfirmed cca exemption with value "([^"]*)"$/ do |value|
  reconfirm_task = FootprintReport.first.reconfirmation_exemption_task

  assert_false("reconfirm task is saved"){reconfirm_task.nil?}
  value_integer = Integer(value)
  assert_true("choice not set") {reconfirm_task.choice == value_integer}
end

Then /^I should have a reconfirmed cca exemption task with incomplete status$/ do
  reconfirm_task = FootprintReport.first.reconfirmation_exemption_task

  assert_false("reconfirm task is saved"){reconfirm_task.nil?}
  assert_true("status not set"){reconfirm_task.status == 0}
end


Then /^I should have a energy supply with non core electricity "([^"]*)" and industrial coal "([^"]*)"$/ do |non, coal|
  energy_supply_task = FootprintReport.first.energy_metrics_task

  assert_false("energy supply not saved"){energy_supply_task.nil?}
  assert_true("non core leccy not set"){energy_supply_task.non_core_electricity == Integer(non) }
  assert_true("coal not set"){energy_supply_task.industrial_coal == Integer(coal)}
end

Then /^I should have a energy supply with complete status$/ do
  energy_supply_task = FootprintReport.first.energy_metrics_task

   assert_false("energy supply not saved"){energy_supply_task.nil?}
   assert_true("energy supply status not complete"){energy_supply_task.status == 2 }
end

Then /^I should have a emission task with core energy ets "([^"]*)" and cca subs "([^"]*)"$/ do |ets, cca_subs|
  emission_task = FootprintReport.first.emission_metrics_task

  assert_false("emission task not saved"){emission_task.nil?}
  assert_true("core energy ets not set"){emission_task.core_energy_ETS == Integer(ets)}
  assert_true("cca subs not set"){emission_task.cca_subsidiaries == Integer(cca_subs)}
end

Then /^I should have a emission task with complete status$/ do
  emission_task = FootprintReport.first.emission_metrics_task

  assert_false("emission task not saved"){emission_task.nil?}
  assert_true("status not set"){emission_task.status == 2}
end

Then /^I should have a residual emission with fuel "([^"]*)" and co2 "([^"]*)"$/ do |fuel, co2|
  residual_emission = FootprintReport.first.residual_emissions_task.residual_emissions.first

  assert_false("residual emission not saved"){residual_emission.nil?}
  assert_true("fuel is not correct"){residual_emission.fuel_list.fuel_name == fuel}
  assert_true("co2 is not correct"){residual_emission.tonnes_c02 == Integer(co2)}
end


Then /^I should have no residual emissions$/ do
  assert_true("residual emission was not removed"){FootprintReport.first.residual_emissions_task.residual_emissions.size == 0}
end

Then /^I should have a complete residual emissions task$/ do
  residual_task = FootprintReport.first.residual_emissions_task

  assert_false("residual task not saved"){residual_task.nil?}
  assert_true("status is not correct"){residual_task.status = 2}
end

Then /^I should have an other fuel with description "([^"]*)" and amount "([^"]*)" and unit "([^"]*)"$/ do |description, amount, unit|
  other_fuel = FootprintReport.first.other_fuels_task.other_fuels.first

  assert_false("other fuel not created"){other_fuel.nil?}
  assert_true("description not set"){other_fuel.description == description}
  assert_true("amount not set"){other_fuel.amount == Integer(amount)}
  assert_true("fuel not set"){other_fuel.unit.name == unit}
end


Then /^I should have no other fuels$/ do
  assert_true("other fuel wasn't removed"){FootprintReport.first.other_fuels_task.other_fuels.size == 0}
end


Then /^I should have a completed other fuels task$/ do
  assert_true("other fuel task status not set"){FootprintReport.first.other_fuels_task.status == 2}
end


