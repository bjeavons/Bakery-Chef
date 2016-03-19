Feature: Data synchronization
  
  Scenario: As a Bakery user, I want changes to my account to be synchronized across sites
    Given I visit "http://masterd7.vbox"
    And I log in as user "test1" with password "1234"
    And I goto my account edit page
    And I change my email to "test1-m@example.com"
    Then I should see the "E-mail address" form value "test1-m@example.com"
    When I visit "http://d7.masterd7.vbox"
    And I goto my account edit page
    Then I should see the "E-mail address" form value "test1-m@example.com"
