Feature: user login
	In order to authenticate with the system
	As an user
	I want to go to a login page and provide login user/password

	Scenario: not logged in can't see normal pages
      When I go to gas readings
      Then I should not see "Enter new gas reading"
        And I should see "Please log in"

    Scenario: not logged in can't edit page
      When I go to edit bad gas reading
      Then I should see "Please log in"

  Scenario: login with good user/pass
    Given I have a user with user "rover" and password "munster"
    When I go to login
    And I fill in "user_session_username" with "rover"
    And I fill in "user_session_password" with "munster"
    And I press "login"
    Then I should see "Successfully logged in"

  Scenario: login with bad user
    Given I have a user with user "rover" and password "munster"
    When I go to login
    And I fill in "user_session_username" with "rover"
    And I fill in "user_session_password" with "leinster"
    And I press "login"
    Then I should see "Password is not valid"

  Scenario: login with bad pass
    Given I have a user with user "rover" and password "munster"
    When I go to login
    And I fill in "user_session_username" with "sexton"
    And I fill in "user_session_password" with "munster"
    And I press "login"
    Then I should see "Username is not valid"

  Scenario: login with good user/pass
    Given I have a user with user "rover" and password "munster"
      When I go to gas readings
      And I follow "Please Login"
      Then I should see "Login"
      When I fill in "user_session_username" with "rover"
        And I fill in "user_session_password" with "munster"
        And I press "login"
      Then I should see "Successfully logged in"
        And I should see "Status"

