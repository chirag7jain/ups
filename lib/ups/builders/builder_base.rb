# frozen_string_literal: true

require 'ox'

module UPS
  module Builders
    # The {BuilderBase} class builds UPS XML Address Objects.
    #
    # @author Paul Trippett
    # @since 0.1.0
    # @abstract
    # @attr [Ox::Document] document The XML Document being built
    # @attr [Ox::Element] root The XML Root
    # @attr [Ox::Element] shipment_root The XML Shipment Element
    # @attr [Ox::Element] access_request The XML AccessRequest Element
    # @attr [String] license_number The UPS API Key
    # @attr [String] user_id The UPS Username
    # @attr [String] password The UPS Password
    class BuilderBase
      include Ox
      include Exceptions

      attr_accessor :document,
                    :root,
                    :shipment_root,
                    :access_request,
                    :license_number,
                    :user_id,
                    :password

      # Initializes a new {BuilderBase} object
      #
      # @param [String] root_name The Name of the XML Root
      # @param [Boolean] instruction_before_root adding instruction before root
      # element for locator use (default false)
      # @return [void]
      def initialize(root_name, instruction_before_root = false)
        initialize_xml_roots root_name

        document << access_request
        document << instruction if instruction_before_root
        document << root

        yield self if block_given?
      end

      # Initializes a new {BuilderBase} object
      #
      # @param [String] license_number The UPS API Key
      # @param [String] user_id The UPS Username
      # @param [String] password The UPS Password
      # @return [void]
      def add_access_request(license_number, user_id, password)
        self.license_number = license_number
        self.user_id = user_id
        self.password = password

        access_request << element_with_value('AccessLicenseNumber',
                                             license_number)
        access_request << element_with_value('UserId', user_id)
        access_request << element_with_value('Password', password)
      end

      # Adds a Request section to the XML document being built
      #
      # @param [String] action The UPS API Action requested
      # @param [String] option The UPS API Option
      # @return [void]
      def add_request(action, option)
        root << Element.new('Request').tap do |request|
          request << element_with_value('RequestAction', action)
          request << element_with_value('RequestOption', option)
        end
      end

      # Adds a Shipper section to the XML document being built
      #
      # @param [Hash] opts A Hash of data to build the requested section
      # @option opts [String] :company_name Company Name
      # @option opts [String] :phone_number Phone Number
      # @option opts [String] :address_line_1 Address Line 1
      # @option opts [String] :city City
      # @option opts [String] :state State
      # @option opts [String] :postal_code Zip or Postal Code
      # @option opts [String] :country Country
      # @option opts [String] :shipper_number UPS Account Number
      # @return [void]
      def add_shipper(opts = {})
        shipment_root << ShipperBuilder.new(opts).to_xml
      end

      # Adds a ShipTo section to the XML document being built
      #
      # @param [Hash] opts A Hash of data to build the requested section
      # @option opts [String] :company_name Company Name
      # @option opts [String] :phone_number Phone Number
      # @option opts [String] :address_line_1 Address Line 1
      # @option opts [String] :city City
      # @option opts [String] :state State
      # @option opts [String] :postal_code Zip or Postal Code
      # @option opts [String] :country Country
      # @return [void]
      def add_ship_to(opts = {})
        shipment_root << OrganisationBuilder.new('ShipTo', opts).to_xml
      end

      # Adds a ShipFrom section to the XML document being built
      #
      # @param [Hash] opts A Hash of data to build the requested section
      # @option opts [String] :company_name Company Name
      # @option opts [String] :phone_number Phone Number
      # @option opts [String] :address_line_1 Address Line 1
      # @option opts [String] :city City
      # @option opts [String] :state State
      # @option opts [String] :postal_code Zip or Postal Code
      # @option opts [String] :country Country
      # @option opts [String] :shipper_number UPS Account Number
      # @return [void]
      def add_ship_from(opts = {})
        shipment_root << OrganisationBuilder.new('ShipFrom', opts).to_xml
      end

      # Adds a Package section to the XML document being built
      #
      # @param [Hash] opts A Hash of data to build the requested section
      # @return [void]
      def add_package(opts = {})
        shipment_root << Element.new('Package').tap do |org|
          org << packaging_type
          org << element_with_value('Description', 'Rate')
          org << package_weight(opts[:weight], opts[:unit])
        end
      end

      # Adds a PaymentInformation section to the XML document being built
      #
      # @param [String] ship_number The UPS Shipper Number
      # @return [void]
      def add_payment_information(ship_number)
        retrieve_or_create_node('PaymentInformation').tap do |payment|
          payment << Element.new('Prepaid').tap do |prepaid|
            prepaid << Element.new('BillShipper').tap do |bill_shipper|
              bill_shipper << element_with_value('AccountNumber', ship_number)
            end
          end
        end
      end

      # Adds a BillThirdParty section to the XML document being built
      #
      # @param [String] account_number UPS Third Party Shipper Account Number
      # @param [String] zip The UPS Third Party Shipper Zip
      # @param [String] country The UPS Third Party Shipper Country
      # @return [void]
      def add_bill_third_party(account_number, zip, country)
        retrieve_or_create_node('PaymentInformation').tap do |payment|
          payment << Element.new('BillThirdParty').tap do |third_party|
            third_party << element_with_value('AccountNumber', account_number)
            third_party << bill_third_party_shipper(zip, country)
          end
        end
      end

      # Adds a RateInformation/NegotiatedRatesIndicator section to the XML
      # document being built
      #
      # @return [void]
      def add_rate_information
        shipment_root << Element.new('RateInformation').tap do |rate_info|
          rate_info << element_with_value('NegotiatedRatesIndicator', '1')
        end
      end

      # Returns a String representation of the XML document being built
      #
      # @return [String]
      def to_xml
        Ox.to_xml document
      end

      private

      def bill_third_party_shipper(zip, country)
        Element.new('BillThirdPartyShipper').tap do |shipper|
          shipper << Element.new('Address').tap do |address|
            address << element_with_value('PostalCode', zip)
            address << element_with_value('CountryCode', country)
          end
        end
      end

      # Get the instruction object to add before a XML object
      #
      # @return []Ox::Instruction]
      def instruction
        instruct = Instruct.new('xml')
        instruct[:version] = '1.0'
        instruct
      end

      def initialize_xml_roots(root_name)
        self.document = Document.new
        self.root = Element.new(root_name)
        self.shipment_root = Element.new('Shipment')
        self.access_request = Element.new('AccessRequest')
        root << shipment_root
      end

      def packaging_type
        code_description 'PackagingType', '02', 'Customer Supplied'
      end

      def package_weight(weight, unit)
        Element.new('PackageWeight').tap do |org|
          org << unit_of_measurement(unit)
          org << element_with_value('Weight', weight)
        end
      end

      def unit_of_measurement(unit)
        Element.new('UnitOfMeasurement').tap do |org|
          org << element_with_value('Code', unit.to_s)
        end
      end

      def element_with_value(name, value)
        raise InvalidAttributeError, name unless value.respond_to?(:to_str)
        Element.new(name).tap do |request_action|
          request_action << value.to_str
        end
      end

      def code_description(name, code, description)
        multi_valued(name, Code: code, Description: description)
      end

      def retrieve_or_create_node(name, parent: shipment_root)
        node = parent.nodes.find { |elem| elem.value == name }
        return node if node
        new_element = Element.new(name)
        parent << new_element
        new_element
      end

      def multi_valued(name, params)
        Element.new(name).tap do |e|
          params.each { |key, value| e << element_with_value(key, value) }
        end
      end
    end
  end
end
