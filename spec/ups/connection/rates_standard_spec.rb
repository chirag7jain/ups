require 'spec_helper'
require 'support/shipping_options'

describe UPS::Connection do
  include ShippingOptions
  include UrlStubbing

  before do
    Typhoeus::Expectation.clear
  end

  let(:stub_path) { File.expand_path("../../../stubs", __FILE__) }
  let(:server) { UPS::Connection.new(test_mode: true) }

  describe "if requesting rates" do
    before do
      add_url_stub(UPS::Connection::TEST_URL, UPS::Connection::RATE_PATH, 'rates_success.xml')
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

    it "should return standard rates" do
      expect(subject.rated_shipments).wont_be_empty
      expect(subject.rated_shipments).must_equal [
        {:service_code=>"11", :service_name=>"UPS Standard", :total=>"25.03"},
        {:service_code=>"65", :service_name=>"UPS Saver", :total=>"45.82"},
        {:service_code=>"54", :service_name=>"Express Plus", :total=>"82.08"},
        {:service_code=>"07", :service_name=>"Express", :total=>"47.77"}
      ]
    end
  end
end
