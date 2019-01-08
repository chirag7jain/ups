# frozen_string_literal: true

module UPS
  module Parsers
    class TrackingParser < ParserBase
      attr_reader :tracking_number,
                  :tracking_status_type,
                  :tracking_status_code,
                  :tracking_status_datetime

      def initialize
        super
        @tracking_status_type = {}
      end

      def end_element(name)
        super
        generate_status_datetime if name == :Activity
      end

      def value(value)
        super
        parse_tracking_number value
        parse_code_of_status_type value
        parse_description_of_status_type value
        parse_status_code value
        parse_status_date value
        parse_status_time value
      end

      private

      attr_reader :status_date, :status_time

      def parse_tracking_number(value)
        return unless switch_active?(*package_element, :TrackingNumber)

        @tracking_number = value.as_s
      end

      def parse_code_of_status_type(value)
        return unless switch_active?(*status_element, :StatusType, :Code)

        @tracking_status_type[:code] = value.as_s
      end

      def parse_description_of_status_type(value)
        return unless switch_active?(*status_element, :StatusType, :Description)

        @tracking_status_type[:description] = value.as_s
      end

      def parse_status_code(value)
        return unless switch_active?(*status_element, :StatusCode, :Code)

        @tracking_status_code = value.as_s
      end

      def parse_status_date(value)
        return unless switch_active?(*package_element, :Activity, :Date)

        @status_date = value.as_s
      end

      def parse_status_time(value)
        return unless switch_active?(*package_element, :Activity, :Time)

        @status_time = value.as_s
      end

      def package_element
        %i(Shipment Package).freeze
      end

      def status_element
        [*package_element, :Activity, :Status].freeze
      end

      def generate_status_datetime
        date_time = "#{status_date} #{status_time}"
        datetime_format = "%Y%m%d #{time_format}"
        @tracking_status_datetime = DateTime.strptime date_time, datetime_format
      end

      def time_format
        status_time.length == 4 ? '%H%M' : '%H%M%S'
      end
    end
  end
end
