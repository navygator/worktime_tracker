Feature: AJAX Relations creation
  @javascript
  Scenario: Add user to approver
    Given a admin visit relations page
    When he click add link
    Then he should see add user dialog
    When he select a user from list
    And he click ok button
    Then he should see user at approved table
