require 'uri'
require 'excon'
require 'digest/md5'
require 'ox'

module UPS
  class Connection
    attr_accessor :url

    TEST_URL = 'https://wwwcie.ups.com'
    LIVE_URL = 'https://onlinetools.ups.com'

    RATE_PATH = '/ups.app/xml/Rate'
    SHIP_PATH = '/ups.app/xml/ShipConfirm'
    ADDRESS_PATH = '/ups.app/xml/XAV'

    DEFAULT_PARAMS = {
      test_mode: false
    }

    def initialize(params = {})
      params = DEFAULT_PARAMS.merge(params)
      self.url = (params[:test_mode]) ? TEST_URL : LIVE_URL
    end

    def rates(rate_builder = {}, &block)
      if rate_builder.empty? && block_given?
        rate_builder = UPS::Builders::RateBuilder.new
        yield rate_builder
      end

      response = Excon.post("#{self.url}#{RATE_PATH}",
                            headers: { "Content-Type" => "application/x-www-form-urlencoded" },
                            body: rate_builder.to_xml)
      response_io = StringIO.new(response.body)

      UPS::Parsers::RatesParser.new.tap do |parser|
        Ox.sax_parse(parser, response_io)
      end
    end
  end
end
