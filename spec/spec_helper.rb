require 'rspec'
require 'rack/test'
require 'webmock/rspec'
require 'vcr'

ENV['RACK_ENV'] = 'test'

require_relative '../app/api/weather_api.rb'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  VCR.configure do |c|
    c.hook_into :webmock
    c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  end
end
