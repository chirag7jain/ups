require 'spec_helper'
require 'ox'
require 'support/shipping_options'

describe UPS::Builders::RateBuilder do
  context "when passed a complete shipment" do
    include_context 'Shipping Options'

    let(:schema) { File.expand_path(File.join(File.dirname(__FILE__), "../../support/RateRequest.xsd")) }
    let(:rate_builder) { UPS::Builders::RateBuilder.new }

    subject { rate_builder.to_xml }

    before do
      rate_builder.add_access_request ENV['UPS_LICENSE_NUMBER'], ENV['UPS_USER_ID'], ENV['UPS_PASSWORD']
      rate_builder.add_shipper shipper
      rate_builder.add_ship_to ship_to
      rate_builder.add_ship_from shipper
      rate_builder.add_package package
    end

    it "should generate a valid XML Request" do
      should pass_validation(schema)
    end
  end
end
