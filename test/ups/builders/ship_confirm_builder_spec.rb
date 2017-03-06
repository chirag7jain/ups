# frozen_string_literal: true
require 'spec_helper'

class UPSBuildersTestShipConfirmBuilder < Minitest::Test
  include SchemaPath
  include ShippingOptions

  def setup
    @ship_confirm_builder = UPS::Builders::ShipConfirmBuilder.new do |builder|
      setup_builder(builder)
    end
  end

  def test_validates_against_xsd
    assert_passes_validation(
      schema_path('ShipConfirmRequest.xsd'),
      @ship_confirm_builder.to_xml
    )
  end

  private

  def setup_builder(builder)
    setup_credentials_builder(builder)
    builder.add_shipper shipper
    builder.add_ship_to ship_to
    builder.add_ship_from shipper
    builder.add_package package
    builder.add_label_specification 'gif', height: '100', width: '100'
    builder.add_description 'Los Pollo Hermanos'
  end

  def setup_credentials_builder(builder)
    builder.add_access_request(
      ENV['UPS_LICENSE_NUMBER'],
      ENV['UPS_USER_ID'],
      ENV['UPS_PASSWORD']
    )
  end
end
