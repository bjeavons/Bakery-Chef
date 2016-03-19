Feature: Subsite registration
  
  Scenario: As a Bakery user, I want to register on a D7 subsite and be authenticated on the others
    Given I visit "http://d7.masterd7.vbox/user/register"
    And I register as a test user
    Then I should be on the site "http://d7.masterd7.vbox/"
    And I should see a link containing the text "My account"
    And I should see a link containing the text "Log out"
    When I visit "http://masterd7.vbox"
    Then I should see a link containing the text "My account"
    And I should see a link containing the text "Log out"
    When I visit "http://d7.masterd7.vbox" 
    Then I should see a link containing the text "My account"
    And I should see a link containing the text "Log out"
