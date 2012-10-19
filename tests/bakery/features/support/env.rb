puts "loading env.rb"
require 'capybara'
require 'capybara/dsl'
require "capybara/cucumber"
require 'capybara/poltergeist'

Capybara.default_driver = :poltergeist

#Usually, we would just use an environment variable for that (ENV['SOMETHING'])
