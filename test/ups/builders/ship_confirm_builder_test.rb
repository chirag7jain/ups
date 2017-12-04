# frozen_string_literal: true
require 'test_helper'

class UPSBuildersTestShipConfirmBuilder < Minitest::Test
  include SchemaPath
  include ShippingOptions

  def setup
    UPS::Builders::ShipConfirmBuilder.new do |builder|
      @ship_confirm_builder = builder
      setup_builder
    end
  end

  def test_validates_against_xsd
    assert_passes_validation
    assert_expected_xml 'ship_confirm_builder.base'
  end

  def test_still_valid_with_email_notifications
    builder.add_email_notifications(
      %w(6 7 012),
      %w(toto@tata.com),
      %w(FRA 97),
      'undelivered@shipper.com'
    )
    assert_passes_validation
    assert_expected_xml 'ship_confirm_builder.notification'
  end

  private

  def assert_passes_validation
    super schema_path('ShipConfirmRequest.xsd'), to_xml
  end

  def assert_expected_xml(file)
    filename = "test/xml_expectations/#{file}.xml"
    File.write filename, to_xml if ENV['REGENERATE']
    assert_equal File.read(filename), to_xml
  end

  def setup_builder
    setup_credentials_builder
    setup_addresses
    builder.add_package package
    builder.add_label_specification 'gif', height: '100', width: '100'
    builder.add_description 'Los Pollo Hermanos'
  end

  def setup_addresses
    builder.add_shipper shipper
    builder.add_ship_to ship_to
    builder.add_ship_from shipper
  end

  def setup_credentials_builder
    builder.add_access_request(
      ENV['UPS_LICENSE_NUMBER'],
      ENV['UPS_USER_ID'],
      ENV['UPS_PASSWORD']
    )
  end

  def builder
    @ship_confirm_builder
  end

  def to_xml
    @xml ||= @ship_confirm_builder.to_xml
  end
end
