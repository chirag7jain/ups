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
    SHIP_CONFIRM_PATH = '/ups.app/xml/ShipConfirm'
    SHIP_ACCEPT_PATH = '/ups.app/xml/ShipAccept'
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

      response = get_response_stream RATE_PATH, rate_builder.to_xml
      UPS::Parsers::RatesParser.new.tap { |parser| Ox.sax_parse(parser, response) }
    end

    def ship(shipment_builder = {}, &block)
      if shipment_builder.empty? && block_given?
        shipment_builder = UPS::Builders::ShipConfirmBuilder.new
        yield shipment_builder
      end

      confirm_response = get_response_stream SHIP_CONFIRM_PATH, shipment_builder.to_xml
      parsed_confirm_response = UPS::Parsers::ShipConfirmParser.new.tap { |parser| Ox.sax_parse(parser, confirm_response) }

      if parsed_confirm_response.success?
        ship_accept_builder = UPS::Builders::ShipAcceptBuilder.new parsed_confirm_response.shipment_digest
        accept_response = get_response_stream SHIP_ACCEPT_PATH, ship_accept_builder.to_xml
        UPS::Parsers::ShipAcceptParser.new.tap { |parser| Ox.sax_parse(parser, accept_response) }
      else
        false
      end
    end

    private

    def build_url(path)
      "#{self.url}#{path}"
    end

    def get_response_stream(path, body)
      response = Excon.post(build_url(path), body: body)
      StringIO.new(response.body)
    end
  end
end
