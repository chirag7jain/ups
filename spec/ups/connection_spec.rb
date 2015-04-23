require "spec_helper"

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

  context "during connect" do
    before do
      Excon.defaults[:mock] = true
      stub_path = File.expand_path("../../stubs", __FILE__)
      Excon.stub({:method => :post}) do |params|
        case params[:path]
        when UPS::Connection::RATE_PATH
          {body: File.read("#{stub_path}/rates_success.xml"), status: 200}
        end
      end
    end

    after do
      Excon.stubs.clear
    end

    let(:server) { UPS::Connection.new(test_mode: true) }

    subject { server.rates({}) }

    it "should return rates" do
      expect { server.rates({}) }.not_to raise_error
      expect(subject.status_code).to eql "1"
      expect(subject.status_description).to eql "Success"
    end
  end
end