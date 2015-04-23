require 'ox'

module UPS
  module Builders
    class RateBuilder < BuilderBase
      include Ox

      attr_accessor :root, :shipment_root

      def initialize
        super
        self.root = Element.new('RatingServiceSelectionRequest')
        self.shipment_root = Element.new('Shipment')

        self.root << self.shipment_root
        self.document << self.root

        add_request
      end

      def add_request
        self.root << Element.new('Request').tap do |request|
          request << element_with_value('RequestAction', 'Rate')
          request << element_with_value('RequestOption', 'Shop')
        end
      end

      def add_shipper(opts = {})
        add_organisation('Shipper', opts)
      end

      def add_ship_to(opts = {})
        add_organisation('ShipTo', opts)
      end

      def add_ship_from(opts = {})
        add_organisation('ShipFrom', opts)
      end

      def add_package(opts = {})
        self.shipment_root << Element.new('Package').tap do |org|
          org << packaging_type
          org << element_with_value('Description', 'Rate')
          org << package_weight(opts[:weight], opts[:unit])
        end
      end

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

      def add_organisation(name, opts = {})
        self.shipment_root << Element.new(name).tap do |org|
          org << element_with_value('CompanyName', opts[:company_name])
          org << element_with_value('PhoneNumber', opts[:phone_number])
          org << element_with_value('ShipperNumber', opts[:shipper_number]) unless opts[:shipper_number].nil?
          org << AddressBuilder.new(opts).to_xml
        end
      end

      def add_payment_information
        self.root << Element.new('PaymentInformation').tap do |payment|
          payment << Element.new('Prepaid').tap do |prepaid|
            prepaid << Element.new('BillShipper').tap do |bill_shipper|
              bill_shipper << element_with_value('AccountNumber', "Ship Number")
            end
          end
        end
      end
    end
  end
end
