puts "loading env.rb"

require 'capybara'
require 'capybara/dsl'
require "capybara/cucumber"
require 'capybara/poltergeist'
begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end

Capybara.default_driver = :poltergeist

#Usually, we would just use an environment variable for that (ENV['SOMETHING'])
