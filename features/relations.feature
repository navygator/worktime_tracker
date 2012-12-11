Feature: AJAX Relations manipulations
  @javascript
  Scenario: Add and remove user approved users
    Given a user sign in as admin
    When he visit relations page
    And he click User link
    And he click Add link
    Then he should see add user dialog
    When he select a user from list
    And he click Ok button
    Then he should see user at approved table
    When he click delete link
    And he accept alert
    Then he should not see user at approved table
