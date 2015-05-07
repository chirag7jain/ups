require 'ox'

module UPS
  module Builders
    class ShipperBuilder < BuilderBase
      include Ox

      attr_accessor :name, :opts

      def initialize(opts = {})
        self.name = name
        self.opts = opts
      end

      def shipper_name
        element_with_value('Name', opts[:company_name])
      end

      def company_name
        element_with_value('CompanyName', opts[:company_name])
      end

      def phone_number
        element_with_value('PhoneNumber', opts[:phone_number])
      end

      def shipper_number
        element_with_value('ShipperNumber', opts[:shipper_number])
      end

      def address
        AddressBuilder.new(opts).to_xml
      end

      def to_xml
        Element.new('Shipper').tap do |org|
          org << shipper_name
          org << company_name
          org << phone_number
          org << shipper_number unless shipper_number.nil?
          org << address
        end
      end
    end
  end
end
