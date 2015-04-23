require 'uri'
require 'ox'

module UPS
  module Parsers
    class ParserBase < ::Ox::Sax
      attr_accessor :switches,
                    :status_code,
                    :status_description

      def initialize
        self.switches = {}
      end

      def start_element(name)
        element_tracker_switch name, true
      end

      def end_element(name)
        element_tracker_switch name, false
      end

      def attr(name, value)
      end

      def text(value)
        self.status_code = value if switch_active? :ResponseStatusCode
        self.status_description = value if switch_active? :ResponseStatusDescription
      end

      def element_tracker_switch element, currently_in
        self.switches[element] = currently_in
      end

      def switch_active? element
        (self.switches[element] == true)
      end
    end
  end
end