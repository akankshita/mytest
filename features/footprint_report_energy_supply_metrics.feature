Feature: energy resupply metrics on footprint report
	In order to complete my footprint report
	As an user
	I want to be able to go to a page off the footprint report and detail my energy supply metrics


  Scenario: set some energy resupply metrics
    Given I have a populated footprint report
    When I am logged in
      And I go to the footprint report
      And I follow "energy supply"
      And I fill in "energy_metrics_task_non_core_electricity" with "66666"
      And I fill in "energy_metrics_task_industrial_coal" with "99999"
      And I press "Update"
    Then I should see "Energy supplies successfully updated."
      And I should have a energy supply with non core electricity "66666" and industrial coal "99999"

  Scenario: set some bad energy resupply metrics
    Given I have a populated footprint report
    When I am logged in
      And I go to the footprint report
      And I follow "energy supply"
      And I fill in "energy_metrics_task_non_core_electricity" with "asdf"
      And I fill in "energy_metrics_task_industrial_coal" with "asdffads@#$24@#$$"
      And I press "Update"
    Then I should see "2 errors"

  Scenario: change energy resupply metrics task status
    Given I have a populated footprint report
    When I am logged in
      And I go to the footprint report
      And I follow "energy supply"
      And I choose "task_status_2"
      And I press "Update"
    Then I should see "Energy supplies successfully updated."
      And I should have a energy supply with complete status