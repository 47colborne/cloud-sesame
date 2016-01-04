require 'rubygems'
require 'bundler/setup'
Bundler.setup

require 'pry'
require 'cloud_search'

RSpec.configure do |config|
  # For running just wanted tests in guard
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end
