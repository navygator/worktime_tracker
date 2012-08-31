Feature: AJAX Relations manipulations
  @javascript
  Scenario: Add user to approver
    Given a user sign in as admin
    When he visit relations page
    And he click User link
    And he click Add link
    Then he should see add user dialog
    When he select a user from list
    And he click ok button
    Then he should see user at approved table

  Scenario: Delete user from approving
    Given a user sign in as admin
    When he visit relations page
    Then he should see Approvers
