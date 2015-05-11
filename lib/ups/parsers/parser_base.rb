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

      def value(value)
        string_value = value.as_s
        self.status_code = string_value if switch_active? :ResponseStatusCode

        if switch_active?(:ResponseStatusDescription)
          self.status_description = string_value
        end

        self.error_description = string_value if switch_active? :ErrorDescription
      end

      def element_tracker_switch(element, currently_in)
        switches[element] = currently_in
      end

      def switch_active?(*elements)
        elements.all? { |element| switches[element] == true }
      end

      def success?
        ['1', 1].include? status_code
      end
    end
  end
end
