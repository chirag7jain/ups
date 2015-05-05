module UPS
  module Parsers
    class RatesParser < ParserBase
      attr_accessor :rated_shipments

      def initialize
        super
        self.rated_shipments = []
        @current_rate = {}
      end

      def start_element(name)
        super
      end

      def end_element(name)
        super
        return unless name == :RatedShipment
        rated_shipments << @current_rate
        @current_rate = {}
      end

      def value(value)
        super
        if switch_active?(:RatedShipment, :Service, :Code)
          parse_service_code value
        elsif switch_active?(:RatedShipment, :TotalCharges)
          parse_total_charges value
        end
      end

      def parse_service_code(value)
        @current_rate[:service_code] = value.as_s
        @current_rate[:service_name] = UPS::SERVICES[value.as_s]
      end

      def parse_total_charges(value)
        @current_rate[:total] = value.as_s
      end
    end
  end
end
