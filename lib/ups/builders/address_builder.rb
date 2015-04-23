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
      end

      def to_xml
        Element.new('Address').tap do |address|
          address << element_with_value('AddressLine1', self.address_line_1)
          address << element_with_value('City', self.city)
          address << element_with_value('StateProvinceCode', self.state)
          address << element_with_value('PostalCode', self.postal_code)
          address << element_with_value('CountryCode', self.country)
        end
      end
    end
  end
end
