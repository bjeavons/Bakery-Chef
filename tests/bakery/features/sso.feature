Feature: SSO
  
  Scenario: As a Bakery user, I want SSO between the master and sub sites
    Given I visit "http://masterd6.vbox"
    And I log in as user "test1" with password "1234"
    Then I should see a link containing the text "My account"
    And I should see a link containing the text "Log out"
    When I visit "http://d6.masterd6.vbox"
    Then I should see a link containing the text "My account"
    And I should see a link containing the text "Log out"
    When I visit "http://d7.masterd6.vbox" 
    Then I should see a link containing the text "My account"
    And I should see a link containing the text "Log out"

  Scenario: As a Bakery user, I want to be able to log into a sub site
    Given I visit "http://d7.masterd6.vbox"
    And I log in as user "test1" with password "1234"
    Then I should see a link containing the text "My account"
    And I should see a link containing the text "Log out"
    When I visit "http://d6.masterd6.vbox"
    Then I should see a link containing the text "My account"
    And I should see a link containing the text "Log out"
    When I visit "http://masterd6.vbox"
    Then I should see a link containing the text "My account"
    And I should see a link containing the text "Log out"
  
  Scenario: As a Bakery user, when I log out of one site I want to be logged out of the others
    Given I visit "http://d7.masterd6.vbox"
    And I log in as user "test1" with password "1234"
    Then I should see a link containing the text "Log out"
    When I click "Log out"
    Then I should not see a link containing the text "My account"
    And I should not see a link containing the text "Log out"
    When I visit "http://masterd6.vbox"
    Then I should not see a link containing the text "My account"
    And I should not see a link containing the text "Log out"
 
