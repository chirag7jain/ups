# frozen_string_literal: true
require 'test_helper'

class UPSBuildersTestShipAcceptBuilder < Minitest::Test
  include SchemaPath

  def setup
    @ship_accept_builder = UPS::Builders::ShipAcceptBuilder.new do |builder|
      builder.add_access_request(
        ENV['UPS_LICENSE_NUMBER'],
        ENV['UPS_USER_ID'],
        ENV['UPS_PASSWORD']
      )
      builder.add_shipment_digest 'rO0ABXNy...HB4cA=='
    end
  end

  def test_validates_against_xsd
    assert_passes_validation(
      schema_path('ShipAcceptRequest.xsd'),
      @ship_accept_builder.to_xml
    )
  end
end
