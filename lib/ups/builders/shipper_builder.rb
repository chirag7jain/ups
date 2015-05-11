require 'ox'

module UPS
  module Builders
    # The {ShipperBuilder} class builds UPS XML Organization Objects.
    #
    # @author Paul Trippett
    # @since 0.1.0
    # @attr [String] name The Containing XML Element Name
    # @attr [Hash] opts The Shipper and Address Parts
    class ShipperBuilder < BuilderBase
      include Ox

      attr_accessor :name, :opts

      # Initializes a new {ShipperBuilder} object
      #
      # @param [Hash] opts The Shipper and Address Parts
      # @option opts [String] :company_name Company Name
      # @option opts [String] :phone_number Phone Number
      # @option opts [String] :address_line_1 Address Line 1
      # @option opts [String] :city City
      # @option opts [String] :state State
      # @option opts [String] :postal_code Zip or Postal Code
      # @option opts [String] :country Country
      def initialize(opts = {})
        self.name = name
        self.opts = opts
      end

      # Returns an XML representation of shipper_name
      #
      # @return [Ox::Element] XML representation of shipper_name
      def shipper_name
        element_with_value('Name', opts[:company_name])
      end

      # Returns an XML representation of company_name
      #
      # @return [Ox::Element] XML representation of company_name
      def company_name
        element_with_value('CompanyName', opts[:company_name])
      end

      # Returns an XML representation of company_name
      #
      # @return [Ox::Element] XML representation of phone_number
      def phone_number
        element_with_value('PhoneNumber', opts[:phone_number])
      end

      # Returns an XML representation of company_name
      #
      # @return [Ox::Element] XML representation of shipper_number
      def shipper_number
        element_with_value('ShipperNumber', opts[:shipper_number] || '')
      end

      # Returns an XML representation of the associated Address
      #
      # @return [Ox::Element] XML object of the associated Address
      def address
        AddressBuilder.new(opts).to_xml
      end

      # Returns an XML representation of the current object
      #
      # @return [Ox::Element] XML representation of the current object
      def to_xml
        Element.new('Shipper').tap do |org|
          org << shipper_name
          org << company_name
          org << phone_number
          org << shipper_number
          org << address
        end
      end
    end
  end
end
