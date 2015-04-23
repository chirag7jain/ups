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
        if name == :RatedShipment
          self.rated_shipments << @current_rate
          @current_rate = {}
        end
        super
      end

      def value(value)
        super
        if switch_active?(:RatedShipment)
          if switch_active?(:Service) && switch_active?(:Code)
            @current_rate[:service_code] = value.as_s
            @current_rate[:service_name] = UPS::SERVICES[value.as_s]
          elsif switch_active?(:TotalCharges)
            @current_rate[:total] = value.as_s
          end
        end
      end
    end
  end
end
