require 'ox'

module UPS
  module Builders
    class BuilderBase
      include Ox
      include UPS::Exceptions

      attr_accessor :document,
                    :root,
                    :shipment_root,
                    :license_number,
                    :user_id,
                    :password

      def initialize(root)
        self.document = Document.new
        self.root = Element.new(root)
        self.shipment_root = Element.new('Shipment')

        self.root << shipment_root
        document << self.root
      end

      def add_access_request(license_number, user_id, password)
        self.license_number = license_number
        self.user_id = user_id
        self.password = password

        document << Element.new('AccessRequest').tap do |access_request|
          access_request << element_with_value('AccessLicenseNumber',
                                               license_number)
          access_request << element_with_value('UserId', user_id)
          access_request << element_with_value('Password', password)
        end
      end

      def add_request(action, option)
        root << Element.new('Request').tap do |request|
          request << element_with_value('RequestAction', action)
          request << element_with_value('RequestOption', option)
        end
      end

      def add_shipper(opts = {})
        shipment_root << ShipperBuilder.new(opts).to_xml
      end

      def add_ship_to(opts = {})
        shipment_root << OrganisationBuilder.new('ShipTo', opts).to_xml
      end

      def add_ship_from(opts = {})
        shipment_root << OrganisationBuilder.new('ShipFrom', opts).to_xml
      end

      def add_package(opts = {})
        shipment_root << Element.new('Package').tap do |org|
          org << packaging_type
          org << element_with_value('Description', 'Rate')
          org << package_weight(opts[:weight], opts[:unit])
        end
      end

      def add_payment_information(ship_number)
        shipment_root << Element.new('PaymentInformation').tap do |payment|
          payment << Element.new('Prepaid').tap do |prepaid|
            prepaid << Element.new('BillShipper').tap do |bill_shipper|
              bill_shipper << element_with_value('AccountNumber', ship_number)
            end
          end
        end
      end

      def to_xml
        Ox.to_xml document
      end

      private

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
        fail InvalidAttributeError, name unless value.respond_to?(:to_str)
        Element.new(name).tap do |request_action|
          request_action << value.to_str
        end
      end

      def code_description(name, code, description)
        Element.new(name).tap do |label_print_method|
          label_print_method << element_with_value('Code', code)
          label_print_method << element_with_value('Description', description)
        end
      end
    end
  end
end
