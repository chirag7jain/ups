# frozen_string_literal: true

require 'test_helper'

class RatesNegotatiedTest < Minitest::Test
  include UrlStubbing

  def setup
    Typhoeus::Expectation.clear
  end

  def test_returns_a_package_with_activities
    stub_tracking_url 'track_success.xml'
    track = server.track do |tracking_builder|
      tracking_builder.add_access_request(
        ENV['UPS_LICENSE_NUMBER'],
        ENV['UPS_USER_ID'],
        ENV['UPS_PASSWORD']
      )
      tracking_builder.add_tracking_number 'ATrackingNumber'
    end
    assert_equal 'ATrackingNumber', track.tracking_number
  end

  private

  EXPECTED_TRACKING_PACKAGE = {}.freeze

  def stub_tracking_url(xml_file_path)
    add_url_stub(
      UPS::Connection::TEST_URL,
      UPS::Connection::TRACKING_PATH,
      xml_file_path
    )
  end

  def stub_path
    @stub_path ||= File.expand_path('../../stubs', __dir__)
  end

  def server
    @server ||= UPS::Connection.new(test_mode: true)
  end
end
