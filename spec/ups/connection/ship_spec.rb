require 'spec_helper'
require 'tempfile'
require 'support/shipping_options'

describe UPS::Connection do
  include ShippingOptions
  include UrlStubbing

  before do
    Typhoeus::Expectation.clear
  end

  let(:stub_path) { File.expand_path("../../../stubs", __FILE__) }
  let(:server) { UPS::Connection.new(test_mode: true) }

  describe "if requesting a shipment" do
    before do
      add_url_stub(UPS::Connection::TEST_URL, UPS::Connection::SHIP_CONFIRM_PATH, 'ship_confirm_success.xml')
      add_url_stub(UPS::Connection::TEST_URL, UPS::Connection::SHIP_ACCEPT_PATH, 'ship_accept_success.xml')
    end

    subject do
      server.ship do |shipment_builder|
        shipment_builder.add_access_request ENV['UPS_LICENSE_NUMBER'], ENV['UPS_USER_ID'], ENV['UPS_PASSWORD']
        shipment_builder.add_shipper shipper
        shipment_builder.add_ship_from shipper
        shipment_builder.add_ship_to ship_to
        shipment_builder.add_package package
        shipment_builder.add_payment_information ENV['UPS_ACCOUNT_NUMBER']
        shipment_builder.add_service '07'
      end
    end

    it "should do what ever it takes to get that shipment shipped!" do
      subject.wont_equal false
      subject.success?.must_equal true
      subject.graphic_image.must_be_kind_of File
      subject.html_image.must_be_kind_of File
      subject.tracking_number.must_equal '1Z2220060292353829'
    end
  end

  describe "ups returns an error during ship confirm" do
    before do
      add_url_stub(UPS::Connection::TEST_URL, UPS::Connection::SHIP_CONFIRM_PATH, 'ship_confirm_failure.xml')
    end

    subject do
      server.ship do |shipment_builder|
        shipment_builder.add_access_request ENV['UPS_LICENSE_NUMBER'], ENV['UPS_USER_ID'], ENV['UPS_PASSWORD']
        shipment_builder.add_shipper shipper
        shipment_builder.add_ship_from shipper
        shipment_builder.add_ship_to ship_to
        shipment_builder.add_package package
        shipment_builder.add_payment_information ENV['UPS_ACCOUNT_NUMBER']
        shipment_builder.add_service '07'
      end
    end

    it "should return a Parsed response with an error code and error description" do
      subject.wont_equal false
      subject.success?.must_equal false
      subject.error_description.must_equal "Missing or invalid shipper number"
    end
  end

  describe "ups returns an error during ship accept" do
    before do
      add_url_stub(UPS::Connection::TEST_URL, UPS::Connection::SHIP_CONFIRM_PATH, 'ship_confirm_success.xml')
      add_url_stub(UPS::Connection::TEST_URL, UPS::Connection::SHIP_ACCEPT_PATH, 'ship_accept_failure.xml')
    end

    subject do
      server.ship do |shipment_builder|
        shipment_builder.add_access_request ENV['UPS_LICENSE_NUMBER'], ENV['UPS_USER_ID'], ENV['UPS_PASSWORD']
        shipment_builder.add_shipper shipper
        shipment_builder.add_ship_from shipper
        shipment_builder.add_ship_to ship_to
        shipment_builder.add_package package
        shipment_builder.add_payment_information ENV['UPS_ACCOUNT_NUMBER']
        shipment_builder.add_service '07'
      end
    end

    it "should return a Parsed response with an error code and error description" do
      subject.wont_equal false
      subject.success?.must_equal false
      subject.error_description.must_equal "Missing or invalid shipper number"
    end
  end
end
