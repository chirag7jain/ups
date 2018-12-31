# frozen_string_literal: true

module UPS
  module Parsers
    class TrackingParser < ParserBase
      attr_reader :tracking_number, :activities

      def initialize
        super
        @activities = []
        @current_activity = {}
      end

      def end_element(name)
        super
        @activities << @current_activity if name == :Activity
      end

      def value(value)
        super
        parse_tracking_number value
        # parse_status_type value
        # parse_status_description value
        # parse_status_code value
        # parse_status_date value
        # parse_status_time value
      end

      private

      def parse_tracking_number(value)
        return unless switch_active?(*package_elements, :TrackingNumber)

        @tracking_number = value.as_s
      end

      def package_elements
        %i[Shipment Package].freeze
      end
    end
  end
end
