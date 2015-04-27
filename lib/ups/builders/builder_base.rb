require 'ox'

module UPS
  module Builders
    class BuilderBase
      include Ox
      include UPS::Exceptions

      attr_accessor :document, :root, :shipment_root, :license_number, :user_id, :password

      def initialize root
        self.document = Document.new
        self.root = Element.new(root)
        self.shipment_root = Element.new('Shipment')

        self.root << self.shipment_root
        self.document << self.root

      end

      def add_access_request license_number, user_id, password
        self.license_number = license_number
        self.user_id = user_id
        self.password = password

        self.document << Element.new('AccessRequest').tap do |access_request|
          access_request << element_with_value('AccessLicenseNumber', license_number)
          access_request << element_with_value('UserId', user_id)
          access_request << element_with_value('Password', password)
        end
      end

      def add_request(action, option)
        self.root << Element.new('Request').tap do |request|
          request << element_with_value('RequestAction', action)
          request << element_with_value('RequestOption', option)
        end
      end

      def add_shipper(opts = {})
        self.shipment_root << Element.new('Shipper').tap do |org|
          org << element_with_value('Name', opts[:company_name])
          org << element_with_value('PhoneNumber', opts[:phone_number])
          org << element_with_value('ShipperNumber', opts[:shipper_number]) unless opts[:shipper_number].nil?
          org << AddressBuilder.new(opts).to_xml
        end
      end

      def add_ship_to(opts = {})
        add_organisation('ShipTo', opts)
      end

      def add_ship_from(opts = {})
        add_organisation('ShipFrom', opts)
      end

      def add_organisation(name, opts = {})
        self.shipment_root << Element.new(name).tap do |org|
          org << element_with_value('CompanyName', opts[:company_name])
          org << element_with_value('PhoneNumber', opts[:phone_number])
          org << element_with_value('AttentionName', opts[:company_name])
          org << AddressBuilder.new(opts).to_xml
        end
      end

      def add_package(opts = {})
        self.shipment_root << Element.new('Package').tap do |org|
          org << packaging_type
          org << element_with_value('Description', 'Rate')
          org << package_weight(opts[:weight], opts[:unit])
        end
      end

      def add_payment_information ship_number
        self.shipment_root << Element.new('PaymentInformation').tap do |payment|
          payment << Element.new('Prepaid').tap do |prepaid|
            prepaid << Element.new('BillShipper').tap do |bill_shipper|
              bill_shipper << element_with_value('AccountNumber', ship_number)
            end
          end
        end
      end

      def to_xml
        Ox.to_xml self.document
      end

      private

      def packaging_type
        Element.new('PackagingType').tap do |org|
          org << element_with_value('Code', '02')
          org << element_with_value('Description', 'Customer Supplied')
        end
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
        raise InvalidAttributeError.new(name) unless value.respond_to?(:to_str)
        Element.new(name).tap do |request_action|
          request_action << value.to_str
        end
      end
    end
  end
end
