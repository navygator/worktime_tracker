Feature: AJAX Relations manipulations
  @javascript
  Scenario: Add user to approver
    Given a admin visit relations page
    When he click Add link
    Then he should see add user dialog
    When he select a user from list
    And he click ok button
    Then he should see user at approved table

  Scenario: Delete user from approving
    Given a admin visit relations page
    When he click delete link
    Then he should see confirmation
    When he click ok button
    Then he should not see user at approved table
