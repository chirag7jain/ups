require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

path = File.expand_path("../../", __FILE__)
require "#{path}/lib/ups.rb"
require 'rspec/xsd'

Dir["#{path}/spec/support/*.rb"].each {|file| require file}

# Set default env parameters to prevent CI failing on pull requests
ENV['UPS_LICENSE_NUMBER'] = '' unless ENV.key? 'UPS_LICENSE_NUMBER'
ENV['UPS_USER_ID'] = '' unless ENV.key? 'UPS_USER_ID'
ENV['UPS_PASSWORD'] = '' unless ENV.key? 'UPS_PASSWORD'
ENV['UPS_ACCOUNT_NUMBER'] = '' unless ENV.key? 'UPS_ACCOUNT_NUMBER'

RSpec.configure do |c|
  c.mock_with :rspec
  c.include RSpec::XSD
end
