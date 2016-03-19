puts "loading env.rb"

require 'capybara'
require 'capybara/dsl'
require "capybara/cucumber"
require 'capybara/poltergeist'
begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end

Capybara.run_server = false

Capybara.default_driver = :poltergeist

# Can be slow with empty caches, give it some time.
Capybara.default_max_wait_time = 120

#Usually, we would just use an environment variable for that (ENV['SOMETHING'])
