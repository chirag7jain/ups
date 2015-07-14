require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

path = File.expand_path('../../', __FILE__)
require "#{path}/lib/ups.rb"

# Set default env parameters to prevent CI failing on pull requests
ENV['UPS_LICENSE_NUMBER'] = '' unless ENV.key? 'UPS_LICENSE_NUMBER'
ENV['UPS_USER_ID'] = '' unless ENV.key? 'UPS_USER_ID'
ENV['UPS_PASSWORD'] = '' unless ENV.key? 'UPS_PASSWORD'
ENV['UPS_ACCOUNT_NUMBER'] = '' unless ENV.key? 'UPS_ACCOUNT_NUMBER'

require 'nokogiri'
require 'minitest/spec'
require 'minitest/autorun'

require 'support/schema_path'
require 'support/shipping_options'
require 'support/xsd_validator'
