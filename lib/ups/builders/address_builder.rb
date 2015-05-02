require 'ox'

module UPS
  module Builders
    class AddressBuilder < BuilderBase
      include Ox

      attr_accessor :opts

      def initialize(opts = {})
        self.opts = opts
        validate
      end

      def validate
        country_code = opts[:country].downcase
        case country_code
        when 'us'
          # TODO: Correctly set US State to two character state code
        when 'ie'
          # TODO: Ensure State is set to irish county
        else
          opts[:state] = ''
        end
      end

      def address_line_1
        element_with_value('AddressLine1', opts[:address_line_1])
      end

      def city
        element_with_value('City', opts[:city])
      end

      def state
        element_with_value('StateProvinceCode', opts[:state])
      end

      def postal_code
        element_with_value('PostalCode', opts[:postal_code])
      end

      def country
        element_with_value('CountryCode', opts[:country])
      end

      def to_xml
        Element.new('Address').tap do |address|
          address << address_line_1
          address << city
          address << state
          address << postal_code
          address << country
        end
      end
    end
  end
end
