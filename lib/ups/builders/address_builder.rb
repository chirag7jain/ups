require 'ox'

module UPS
  module Builders
    class AddressBuilder < BuilderBase
      include Ox

      attr_accessor :address_line_1, :city, :state, :postal_code, :country

      def initialize(opts = {})
        self.address_line_1 = opts[:address_line_1]
        self.city = opts[:city]
        self.state = opts[:state]
        self.postal_code = opts[:postal_code]
        self.country = opts[:country]

        validate
      end

      def validate
        country_code = country.downcase
        case country_code
        when 'us'
          # TODO: Correctly set US State to two character state code
        when 'ie'
          # TODO: Ensure State is set to irish county
        else
          self.state = ''
        end
      end

      def to_xml
        Element.new('Address').tap do |address|
          address << element_with_value('AddressLine1', address_line_1)
          address << element_with_value('City', city)
          address << element_with_value('StateProvinceCode', state)
          address << element_with_value('PostalCode', postal_code)
          address << element_with_value('CountryCode', country)
        end
      end
    end
  end
end
