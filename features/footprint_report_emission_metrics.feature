Feature: emission metrics on footprint report
	In order to complete my footprint report
	As an user
	I want to be able to go to a page off the footprint report and detail my emission metrics

  Scenario: set some emission metrics
    Given I have a populated footprint report
    When I am logged in
      And I go to the footprint report
      And I follow "ETS and CCA metrics"
      And I fill in "emission_metrics_task_core_energy_ETS" with "77777"
      And I fill in "emission_metrics_task_cca_subsidiaries" with "88888"
      And I press "Update"
    Then I should see "Report metric emissions were successfully updated."
      And I should have a emission task with core energy ets "77777" and cca subs "88888"

  Scenario: set some bad energy resupply metrics
    Given I have a populated footprint report
    When I am logged in
      And I go to the footprint report
      And I follow "ETS and CCA metrics"
      And I fill in "emission_metrics_task_core_energy_ETS" with "asdf"
      And I fill in "emission_metrics_task_cca_subsidiaries" with "asfd"
      And I press "Update"
    Then I should see "2 errors"

  Scenario: change energy resupply metrics task status
    Given I have a populated footprint report
    When I am logged in
      And I go to the footprint report
      And I follow "ETS and CCA metrics"
      And I choose "task_status_2"
      And I press "Update"
    Then I should see "Report metric emissions were successfully updated."
      And I should have a emission task with complete status