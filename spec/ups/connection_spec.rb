require 'spec_helper'
require 'support/shipping_options'

describe UPS::Connection do
  context "when setting test mode" do
    subject { UPS::Connection.new(test_mode: true) }

    it "should set the uri to the test url" do
      expect(subject.url).to eql UPS::Connection::TEST_URL
    end
  end

  context "when setting live mode" do
    subject { UPS::Connection.new }

    it "should set the uri to the live url" do
      expect(subject.url).to eql UPS::Connection::LIVE_URL
    end
  end
end
