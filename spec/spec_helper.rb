require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

path = File.expand_path("../../", __FILE__)
require "#{path}/lib/ups.rb"
require 'rspec/xsd'

Dir["#{path}/spec/support/*.rb"].each {|file| require file}

RSpec.configure do |c|
  c.mock_with :rspec
  c.include RSpec::XSD
end
