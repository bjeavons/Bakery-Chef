Feature: Destination redirection
  
  Scenario: As a Bakery user, I want my query arguments to carry through login on D6
    Given I visit "http://d6.masterd6.vbox/user/login?s=foo"
    And I enter user "test1" with password "1234"
    Then I should be on the site "http://d6.masterd6.vbox/"
    And I should have "s=foo" in the URL
  
  Scenario: As a Bakery user, I want my destination to carry through registration on D6
    Given I visit "http://d6.masterd6.vbox/user/register?s=bar"
    And I register as a test user
    Then I should be on the site "http://d6.masterd6.vbox/"
    And I should have "s=bar" in the URL

  @do
  Scenario: As a Bakery user, I want my query arguments to carry through login on D7
    Given I visit "http://d7.masterd7.vbox/user/login?s=foo"
    And I enter user "test1" with password "1234"
    Then I should be on the site "http://d7.masterd7.vbox/"
    And I should have "s=foo" in the URL
  
  Scenario: As a Bakery user, I want my query arguments to carry through registration on D7
    Given I visit "http://d7.masterd7.vbox/user/register?s=bar"
    And I register as a test user
    Then I should be on the site "http://d7.masterd7.vbox/"
    And I should have "s=bar" in the URL
