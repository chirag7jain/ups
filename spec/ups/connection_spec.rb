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

  let(:stub_path) { File.expand_path("../../stubs", __FILE__) }
  let(:server) { UPS::Connection.new(test_mode: true) }

  context "when setting test mode" do
    subject { UPS::Connection.new(test_mode: true) }

    it "should set the uri to the test url" do
      expect(subject.url).to eql UPS::Connection::TEST_URL
    end
  end

  context "when setting live mode" do
    subject { UPS::Connection.new }

    it "should set the uri to the live url" do
      expect(subject.url).to eql UPS::Connection::LIVE_URL
    end
  end

  context "if requesting rates" do
    before do
      Excon.stub({:method => :post}) do |params|
        case params[:path]
        when UPS::Connection::RATE_PATH
          {body: File.read("#{stub_path}/rates_success.xml"), status: 200}
        end
      end
    end

    subject do
      server.rates do |rate_builder|
        rate_builder.add_access_request ENV['UPS_LICENSE_NUMBER'], ENV['UPS_USER_ID'], ENV['UPS_PASSWORD']
        rate_builder.add_shipper shipper
        rate_builder.add_ship_from shipper
        rate_builder.add_ship_to ship_to
        rate_builder.add_package package
      end
    end

    it "should return rates" do
      expect { subject }.not_to raise_error
      expect(subject.rated_shipments).not_to be_empty
      expect(subject.rated_shipments).to eql [
        {:service_code=>"11", :service_name=>"UPS Standard", :total=>"25.03"},
        {:service_code=>"65", :service_name=>"UPS Saver", :total=>"45.82"},
        {:service_code=>"54", :service_name=>"Express Plus", :total=>"82.08"},
        {:service_code=>"07", :service_name=>"Express", :total=>"47.77"}
      ]
    end
  end

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

  context "ups returns an error diring ship confirm" do
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
