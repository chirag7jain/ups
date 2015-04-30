require 'uri'
require 'ox'

module UPS
  module Parsers
    class ParserBase < ::Ox::Sax
      attr_accessor :switches,
                    :status_code,
                    :status_description,
                    :error_description

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

      def value(value)
        self.status_code = value.as_s if switch_active? :ResponseStatusCode
        self.status_description = value.as_s if switch_active? :ResponseStatusDescription
        self.error_description = value.as_s if switch_active? :ErrorDescription
      end

      def element_tracker_switch element, currently_in
        self.switches[element] = currently_in
      end

      def switch_active? element
        (self.switches[element] == true)
      end

      def success?
        ['1', 1].include? self.status_code
      end
    end
  end
end