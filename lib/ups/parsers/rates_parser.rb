module UPS
  module Parsers
    class RatesParser < ParserBase
      def start_element(name)
        super
      end

      def end_element(name)
        super
      end

      def attr(name, value)
        super
      end

      def text(value)
        super
      end
    end
  end
end
