=begin

Capybara:
  Most important things are here:
  https://github.com/jnicklas/capybara/blob/master/README.md
  The full documentation is here:
  http://rubydoc.info/github/jnicklas/capybara/master

#Examples

  #When /^I click (?:on )?["'](.*)['"]$/ do |link|
  #  click_link(link)
  #end

  #Then /^there should be a button called ['"](.*)['"]$/ do |button_name|
  #  page.should have_button(button_name)
  #end

=end

Given /^I visit "(.*?)"$/ do |site|
  Capybara.app_host = site
  visit('/')
end

Given /^I am visiting the homepage$/ do
  visit('/')
end

Then /^I should be on the site "(.*?)"$/ do |site|
  page.current_host.chomp('/').should == site.chomp('/')
end

Then /^I should (not )?see a title containing the word "(.*?)"$/ do |present, text|
  if present
    page.should_not have_css('title', :text => text)
  else 
    page.should have_css('title', :text => text)
  end
end

Given /^I search for '(.*)'$/ do |text|
  fill_in('edit-search-block-form--2', :with => text)
  find(:css, 'input#edit-submit').click
end

Then /^I should see (no|a lot of) search results$/ do |amount|
  if amount == 'a lot of'
    all('li.search-result').size.should >= 4
  else 
    all('li.search-result').size.should == 0
  end
end

Then /^I should see the text "(.*?)"$/ do |text|
  page.should have_content(text)
end

Then /^I should see the (.*?) form value "(.*?)"$/ do |name, text|
  page.has_field?(name, :value => text)
end

Given /^I log in as user "(.*?)" with password "(.*?)"$/ do |user, pass|
  visit('/user/login')
  within('#user-login') do
    fill_in 'Username', :with => user
    fill_in 'Password', :with => pass
  end
  click_button('Log in')
end

Given /^I enter user "(.*?)" with password "(.*?)"$/ do |user, pass|
  within('#user-login') do
    fill_in 'Username', :with => user
    fill_in 'Password', :with => pass
  end
  click_button('Log in') 
end

Given /^I register as a test user$/ do
  id = 4.times.map { rand(9) }.join
  username = "test#{id}"
  mail = "#{username}@example.com"
  pass = 1234
  if page.has_selector?('#user-register')
    within('#user-register') do
      fill_in 'Username', :with => username
      fill_in 'E-mail address', :with => mail
      fill_in 'Password', :with => pass
      fill_in 'Confirm password', :with => pass
    end
    click_button('Create new account')
  elsif page.has_selector?('#user-register-form')
    within('#user-register-form') do
      fill_in 'Username', :with => username
      fill_in 'E-mail address', :with => mail
      fill_in 'Password', :with => pass
      fill_in 'Confirm password', :with => pass
    end
    click_button('Create new account')
  end
end

Given /^I goto my account edit page$/ do
  visit('/user')
  click_link 'Edit'
end

Given /^I change my email to "(.*?)"$/ do |change|
  within('#user-profile-form') do
    fill_in 'E-mail address', :with => change
  end
  click_button('Save')
end

Then /^I should see a link containing the text "(.*?)"$/ do |text|
  find_link(text).visible? 
end

When /^I click "(.*?)"$/ do |text|
  click_link text
end

Then /^I should not see a link containing the text "(.*?)"$/ do |text|
  page.should have_no_content(text)
end
