require "spec_helper"

require 'tempfile'

describe UPS::Connection do
  before do
    Excon.defaults[:mock] = true
    stub_path = File.expand_path("../../stubs", __FILE__)
    Excon.stub({:method => :post}) do |params|
      case params[:path]
      when UPS::Connection::RATE_PATH
        {body: File.read("#{stub_path}/rates_success.xml"), status: 200}
      when UPS::Connection::SHIP_CONFIRM_PATH
        {body: File.read("#{stub_path}/ship_confirm_success.xml"), status: 200}
      when UPS::Connection::SHIP_ACCEPT_PATH
        {body: File.read("#{stub_path}/ship_accept_success.xml"), status: 200}
      end
    end
  end

  after do
    Excon.stubs.clear
  end

  let(:server) { UPS::Connection.new(test_mode: true) }
  let(:shipper) { {
    company_name: 'Veeqo Limited',
    phone_number: '01792 123456',
    address_line_1: '11 Wind Street',
    city: 'Swansea',
    state: 'Wales',
    postal_code: 'SA1 1DA',
    country: 'GB',
    shipper_number: ENV['UPS_ACCOUNT_NUMBER']
  } }
  let(:ship_to) { {
    company_name: 'Google Inc.',
    phone_number: '0207 031 3000',
    address_line_1: '1 St Giles High Street',
    city: 'London',
    state: 'England',
    postal_code: 'WC2H 8AG',
    country: 'GB'
  } }
  let(:package) { {
    weight: '0.5',
    unit: 'KGS'
  } }

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
    end
  end

  context "if requesting a shipment" do
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
    end
  end
end
