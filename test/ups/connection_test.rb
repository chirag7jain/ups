# frozen_string_literal: true

require 'test_helper'
require 'support/shipping_options'

class UpsConnectionTest < Minitest::Test
  def test_that_it_sets_the_uri_to_the_test_url
    subject = UPS::Connection.new(test_mode: true)
    assert_equal UPS::Connection::TEST_URL, subject.url
  end

  def test_that_it_sets_the_uri_to_the_live_url
    subject = UPS::Connection.new
    assert_equal UPS::Connection::LIVE_URL, subject.url
  end
end
