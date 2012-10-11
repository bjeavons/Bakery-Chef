puts "loading env.rb"
require 'capybara'
require 'capybara/dsl'
require "capybara/cucumber"

Capybara.default_driver = :selenium

#Usually, we would just use an environment variable for that (ENV['SOMETHING'])
