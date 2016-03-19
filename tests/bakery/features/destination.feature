Feature: Destination redirection
  
  Scenario: As a Bakery user, I want my destination to carry through login on D7
    Given I visit "http://d7.masterd7.vbox/user/login?destination=filter/tips"
    And I enter user "test1" with password "1234"
    Then I should be on the site "http://d7.masterd7.vbox/"
    And I should see the text "Compose tips"
    And I should see a link containing the text "My account"
    And I should see a link containing the text "Log out"
  
  Scenario: As a Bakery user, I want my destination to carry through registration on D7
    Given I visit "http://d7.masterd7.vbox/user/register?destination=filter/tips"
    And I register as a test user
    Then I should be on the site "http://d7.masterd7.vbox/"
    And I should see the text "Compose tips"
    And I should see a link containing the text "My account"
    And I should see a link containing the text "Log out"
