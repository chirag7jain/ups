# frozen_string_literal: true
require 'test_helper'

class RatesNegotatiedTest < Minitest::Test
  include ShippingOptions
  include UrlStubbing

  def setup
    Typhoeus::Expectation.clear
  end

  def test_returns_negotatied_rates
    stub_rates_url
    rates = server.rates do |rate_builder|
      setup_rate_builder(rate_builder)
    end
    assert_equal EXPECTED_RATED_SHIPMENTS, rates.rated_shipments
  end

  #   it "should return neotiated rates" do
  #     expect(subject.rated_shipments).wont_be_empty
  #     expect(subject.rated_shipments).must_equal [
  #       {:service_code=>"11", :service_name=>"UPS Standard", :total=>"24.78"},
  #       {:service_code=>"65", :service_name=>"UPS Saver", :total=>"45.15"},
  #       {:service_code=>"54", :service_name=>"Express Plus", :total=>"80.89"},
  #       {:service_code=>"07", :service_name=>"Express", :total=>"47.08"}
  #     ]
  #   end
  # end

  private

  EXPECTED_RATED_SHIPMENTS = [
    { service_code: '11', service_name: 'UPS Standard', total: '24.78' },
    { service_code: '65', service_name: 'UPS Saver', total: '45.15' },
    { service_code: '54', service_name: 'Express Plus', total: '80.89' },
    { service_code: '07', service_name: 'Express', total: '47.08' }
  ].freeze

  def stub_rates_url
    add_url_stub(
      UPS::Connection::TEST_URL,
      UPS::Connection::RATE_PATH,
      'rates_negotiated_success.xml'
    )
  end

  def setup_rate_builder(rate_builder)
    rate_builder.add_access_request(
      ENV['UPS_LICENSE_NUMBER'],
      ENV['UPS_USER_ID'],
      ENV['UPS_PASSWORD']
    )
    rate_builder.add_shipper shipper
    rate_builder.add_ship_from shipper
    rate_builder.add_ship_to ship_to
    rate_builder.add_package package
    rate_builder.add_rate_information
  end

  def stub_path
    @stub_path ||= File.expand_path('../../../stubs', __FILE__)
  end

  def server
    @server ||= UPS::Connection.new(test_mode: true)
  end
end
