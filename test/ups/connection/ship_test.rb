# frozen_string_literal: true
require 'test_helper'
require 'tempfile'
require 'support/shipping_options'

class UpsConnectionShipTest < Minitest::Test
  include ShippingOptions
  include UrlStubbing

  def setup
    Typhoeus::Expectation.clear
  end

  def test_that_it_does_whatever_it_takes_to_get_that_shipment_shipped!
    stub_ship_confirm_url 'ship_confirm_success.xml'
    stub_ship_accept_url 'ship_accept_success.xml'
    subject = server.ship do |shipment_builder|
      setup_shipment_builder(shipment_builder)
    end

    refute_equal false, subject
    assert_equal true, subject.success?

    assert_kind_of File, subject.graphic_image
    assert_kind_of File, subject.html_image
    assert_equal '1Z2220060292353829', subject.tracking_number
  end

  def test_ups_returns_an_error_during_ship_confirm
    stub_ship_confirm_url 'ship_confirm_failure.xml'
    subject = server.ship do |shipment_builder|
      setup_shipment_builder(shipment_builder)
    end
    refute_equal false, subject
    assert_equal false, subject.success?
    assert_equal 'Missing or invalid shipper number', subject.error_description
  end

  private

  def setup_shipment_builder(shipment_builder)
    setup_credentials shipment_builder
    shipment_builder.add_shipper shipper
    shipment_builder.add_ship_from shipper
    shipment_builder.add_ship_to ship_to
    shipment_builder.add_package package
    shipment_builder.add_payment_information ENV['UPS_ACCOUNT_NUMBER']
    shipment_builder.add_service '07'
  end

  def setup_credentials(shipment_builder)
    shipment_builder.add_access_request(
      ENV['UPS_LICENSE_NUMBER'],
      ENV['UPS_USER_ID'],
      ENV['UPS_PASSWORD']
    )
  end

  def stub_ship_accept_url(xml_file_path)
    add_url_stub(
      UPS::Connection::TEST_URL,
      UPS::Connection::SHIP_ACCEPT_PATH,
      xml_file_path
    )
  end

  def stub_ship_confirm_url(xml_file_path)
    add_url_stub(
      UPS::Connection::TEST_URL,
      UPS::Connection::SHIP_CONFIRM_PATH,
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

#   describe "ups returns an error during ship accept" do
#     before do
#       add_url_stub(UPS::Connection::TEST_URL, UPS::Connection::SHIP_CONFIRM_PATH, 'ship_confirm_success.xml')
#       add_url_stub(UPS::Connection::TEST_URL, UPS::Connection::SHIP_ACCEPT_PATH, 'ship_accept_failure.xml')
#     end

#     subject do
#       server.ship do |shipment_builder|
#         shipment_builder.add_access_request ENV['UPS_LICENSE_NUMBER'], ENV['UPS_USER_ID'], ENV['UPS_PASSWORD']
#         shipment_builder.add_shipper shipper
#         shipment_builder.add_ship_from shipper
#         shipment_builder.add_ship_to ship_to
#         shipment_builder.add_package package
#         shipment_builder.add_payment_information ENV['UPS_ACCOUNT_NUMBER']
#         shipment_builder.add_service '07'
#       end
#     end

#     it "should return a Parsed response with an error code and error description" do
#       subject.wont_equal false
#       subject.success?.must_equal false
#       subject.error_description.must_equal "Missing or invalid shipper number"
#     end
#   end
# end
