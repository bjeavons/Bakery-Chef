puts "loading env.rb"
require 'capybara'
require 'capybara/dsl'
require "capybara/cucumber"
require 'capybara/mechanize/cucumber'

Capybara.default_driver = :mechanize

#Usually, we would just use an environment variable for that (ENV['SOMETHING'])
