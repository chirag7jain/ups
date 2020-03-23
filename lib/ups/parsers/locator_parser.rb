# frozen_string_literal: true

module UPS
  module Parsers
    class LocatorParser < ParserBase
      attr_accessor :company_name,
                    :address_line_1,
                    :city,
                    :postal_code,
                    :country

      def end_element(name)
        super
        generate_status_datetime if name == :Activity
      end

      def value(value)
        super
        parse_address value if switch_active?(:DropLocation, :AddressKeyFormat)
      end

      private

      def parse_address(value)
        if switch_active?(:ConsigneeName)
          @company_name = value.as_s
        elsif switch_active?(:AddressLine)
          @address_line_1 = value.as_s
        elsif switch_active?(:PoliticalDivision2)
          @city = value.as_s
        elsif switch_active?(:PostcodePrimaryLow)
          @postal_code = value.as_s
        elsif switch_active?(:CountryCode)
          @country = value.as_s
        end
      end
    end
  end
end
