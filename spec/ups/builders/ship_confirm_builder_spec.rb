require 'spec_helper'
require 'ox'
require 'support/shipping_options'

describe UPS::Builders::ShipConfirmBuilder do
  context "when passed a complete shipment" do
    include_context 'Shipping Options'

    let(:schema) { File.expand_path(File.join(File.dirname(__FILE__), "../../support/ShipConfirmRequest.xsd")) }
    let(:ship_confirm_builder) { UPS::Builders::ShipConfirmBuilder.new }

    subject { ship_confirm_builder.to_xml }

    before do
      ship_confirm_builder.add_access_request ENV['UPS_LICENSE_NUMBER'], ENV['UPS_USER_ID'], ENV['UPS_PASSWORD']
      ship_confirm_builder.add_shipper shipper
      ship_confirm_builder.add_ship_to ship_to
      ship_confirm_builder.add_ship_from shipper
      ship_confirm_builder.add_package package
      ship_confirm_builder.add_label_specification 'gif', { height: '100', width: '100' }
      ship_confirm_builder.add_description 'Los Pollo Hermanos'
    end

    it "should generate a valid XML Request" do
      should pass_validation(schema)
    end
  end
end
