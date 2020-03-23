
# frozen_string_literal: true

require 'test_helper'

class UPSBuildersTestLocatorBuilder < Minitest::Test
  include SchemaPath
  include ShippingOptions

  def setup
    @rate_builder = UPS::Builders::LocatorBuilder.new do |builder|
      setup_builder(builder)
    end
  end

  def test_validates_against_xsd
    assert_passes_validation(
      schema_path('LocatorRequest.xsd'),
      @rate_builder.to_xml
    )
  end

  private

  def setup_builder(builder)
    builder.add_access_request(
      ENV['UPS_LICENSE_NUMBER'],
      ENV['UPS_USER_ID'],
      ENV['UPS_PASSWORD']
    )
    builder.add_location_number 'U76511081'
    builder.add_translation 'FRA'
    builder.add_origin_country
  end
end
