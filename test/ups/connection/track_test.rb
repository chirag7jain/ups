# frozen_string_literal: true

require 'test_helper'

class RatesNegotatiedTest < Minitest::Test
  include UrlStubbing

  def setup
    Typhoeus::Expectation.clear
  end

  def test_track_with_success
    stub_tracking_url 'track_success.xml'
    assert track.success?
  end

  def test_returns_a_package_with_activities
    stub_tracking_url 'track_success.xml'
    assert_equal 'ATrackingNumber', track.tracking_number
    assert_equal expected_status_type, track.tracking_status_type
    assert_equal 'KB', track.tracking_status_code
    assert_equal expected_datetime, track.tracking_status_datetime
  end

  private

  EXPECTED_TRACKING_PACKAGE = {}.freeze

  def track
    @track ||= server.track do |tracking_builder|
      tracking_builder.add_access_request(
        ENV['UPS_LICENSE_NUMBER'],
        ENV['UPS_USER_ID'],
        ENV['UPS_PASSWORD']
      )
      tracking_builder.add_tracking_number 'ATrackingNumber'
    end
  end

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

  def expected_datetime
    DateTime.parse('2003-03-13T16:00:00+00:00', false)
  end

  def expected_status_type
    { code: 'D', description: 'DELIVERED' }
  end
end
