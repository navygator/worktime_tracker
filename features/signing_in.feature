Feature: Signin in
  Scenario: Unsuccessful signin
    Given a employee visits signin page
    When he submit invalid signin information
    Then he should see an error message

  Scenario: Successful signin
    Given a employee visits signin page
    And the employee has an account
    And the employee submits valid signin information
    Then he should see his profile page
    And he should see a signout link
