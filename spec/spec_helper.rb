require 'rubygems'
require 'bundler/setup'
Bundler.setup

require 'pry'
require 'helpers/benchmark_helper'
require 'cloud_sesame'

RSpec.configure do |config|
  # For running just wanted tests in guard
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.extend BenchmarkHelper
end
