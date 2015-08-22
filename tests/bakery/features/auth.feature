Feature: Authentication

	Scenario: As a Bakery user I would like to authenticate onto a subsite and not receive 403 if I visit bakery/login
		Given I visit "http://d6.masterd6.vbox"
		And I log in as user "test1" with password "1234"
		When I visit path "/bakery/login"
    Then I should not see the text "Access denied"
		#Then I should have a response code of 200

	Scenario: As a Bakery user I would like to authenticate onto a D7 subsite and not receive 403 if I visit bakery/login
		Given I visit "http://d7.masterd6.vbox"
		And I log in as user "test1" with password "1234"
		When I visit path "/bakery/login"
		Then I should not see the text "Access denied"
		#Then I should have a response code of 200
