# frozen_string_literal: true

require 'test_helper'
require 'tempfile'
require 'support/shipping_options'

class UpsConnectionLocatorTest < Minitest::Test
  include ShippingOptions
  include UrlStubbing

  def setup
    Typhoeus::Expectation.clear
  end

  def test_that_locator_request_work
    stub_locator_url 'locator_success.xml'
    subject = server.locator do |locator_builder|
      setup_locator_builder(locator_builder)
    end

    refute_equal false, subject
    assert_equal true, subject.success?

    assert_equal 'L\'ALTHA ', subject.company_name
    assert_equal '1 PLACE DES 37 CANADIENS', subject.address_line_1
    assert_equal 'AUTHIE', subject.city
    assert_equal '14280', subject.postal_code
    assert_equal 'FR', subject.country
  end

  def test_ups_returns_an_error_during_ship_confirm
    stub_locator_url 'locator_failure.xml'
    subject = server.locator do |locator_builder|
      setup_locator_builder(locator_builder)
      locator_builder.add_origin_country 'US'
    end
    refute_equal false, subject
    assert_equal false, subject.success?
    assert_equal 'The Country code is missing.', subject.error_description
  end

  private

  def setup_locator_builder(locator_builder)
    setup_credentials locator_builder
    locator_builder.add_location_number 'U76511081'
    locator_builder.add_translation 'FRA'
  end

  def setup_credentials(locator_builder)
    locator_builder.add_access_request(
      ENV['UPS_LICENSE_NUMBER'],
      ENV['UPS_USER_ID'],
      ENV['UPS_PASSWORD']
    )
  end

  def stub_locator_url(xml_file_path)
    add_url_stub(
      UPS::Connection::TEST_URL,
      UPS::Connection::LOCATOR_PATH,
      xml_file_path
    )
  end

  def stub_path
    @stub_path ||= File.expand_path('../../../stubs', __FILE__)
  end

  def server
    @server ||= UPS::Connection.new(test_mode: true)
  end
end
