require 'spec_helper'
require 'tempfile'
require 'support/shipping_options'

describe UPS::Connection do
  before do
    Excon.defaults[:mock] = true
  end

  after do
    Excon.stubs.clear
  end

  include_context 'Shipping Options'

  let(:stub_path) { File.expand_path("../../../stubs", __FILE__) }
  let(:server) { UPS::Connection.new(test_mode: true) }

  context "if requesting a shipment" do
    before do
      Excon.stub({:method => :post}) do |params|
        case params[:path]
        when UPS::Connection::SHIP_CONFIRM_PATH
          {body: File.read("#{stub_path}/ship_confirm_success.xml"), status: 200}
        when UPS::Connection::SHIP_ACCEPT_PATH
          {body: File.read("#{stub_path}/ship_accept_success.xml"), status: 200}
        end
      end
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
      expect { subject }.not_to raise_error
      expect(subject).not_to eql false
      expect(subject.success?).to eql true
      expect(subject.graphic_image).to be_a Tempfile
      expect(subject.html_image).to be_a Tempfile
      expect(subject.tracking_number).to eql '1Z2220060292353829'
    end
  end

  context "ups returns an error during ship confirm" do
    before do
      Excon.stub({:method => :post}) do |params|
        case params[:path]
        when UPS::Connection::SHIP_CONFIRM_PATH
          {body: File.read("#{stub_path}/ship_confirm_failure.xml"), status: 200}
        end
      end
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
      expect { subject }.not_to raise_error
      expect(subject).not_to eql false
      expect(subject.success?).to eql false
      expect(subject.error_description).to eql "Missing or invalid shipper number"
    end
  end

  context "ups returns an error during ship accept" do
    before do
      Excon.stub({:method => :post}) do |params|
        case params[:path]
        when UPS::Connection::SHIP_CONFIRM_PATH
          {body: File.read("#{stub_path}/ship_confirm_success.xml"), status: 200}
        when UPS::Connection::SHIP_ACCEPT_PATH
          {body: File.read("#{stub_path}/ship_accept_failure.xml"), status: 200}
        end
      end
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
      expect { subject }.not_to raise_error
      expect(subject).not_to eql false
      expect(subject.success?).to eql false
      expect(subject.error_description).to eql "Missing or invalid shipper number"
    end
  end
end
