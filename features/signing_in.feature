Feature: Signin in
  Scenario: Unsuccessful signin
    Given a user visits signin page
    When he submit invalid signin information
    Then he should see an error message

  Scenario: Successful signin
    Given a user visits signin page
    And the user has an account
    And the user submits valid signin information
    Then he should see his profile page
    And he should see a signout link
