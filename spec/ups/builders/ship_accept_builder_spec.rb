require 'spec_helper'
require 'ox'
require 'support/shipping_options'

describe UPS::Builders::ShipAcceptBuilder do
  context "when passed a complete shipment" do
    include_context 'Shipping Options'

    let(:schema) { File.expand_path(File.join(File.dirname(__FILE__), "../../support/ShipAcceptRequest.xsd")) }
    let(:ship_confirm_builder) { UPS::Builders::ShipAcceptBuilder.new }

    subject { ship_confirm_builder.to_xml }

    before do
      ship_confirm_builder.add_access_request ENV['UPS_LICENSE_NUMBER'], ENV['UPS_USER_ID'], ENV['UPS_PASSWORD']
      ship_confirm_builder.add_shipment_digest "rO0ABXNy...HB4cA=="
    end

    it "should generate a valid XML Request" do
      should pass_validation(schema)
    end
  end
end
