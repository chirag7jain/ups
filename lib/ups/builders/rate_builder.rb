require 'ox'

module UPS
  module Builders
    class RateBuilder < BuilderBase
      include Ox

      attr_accessor :document, :root

      def initialize
        self.document = Document.new
        self.root = Element.new('RatingServiceSelectionRequest')
        self.document << self.root
      end

      def add_request
        self.document << Element.new('Request').tap do |request|
          request << element_with_value('RequestAction', 'Rate')
          request << element_with_value('RequestOption', 'Rate')
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

      def add_organisation(name, opts = {})
        self.document << Element.new(name).tap do |org|
          org << element_with_value('CompanyName', opts[:company_name])
          org << element_with_value('PhoneNumber', opts[:phone_number])
          org << element_with_value('ShipperNumber', opts[:shipper_number])
          org << AddressBuilder.new(opts)
        end
      end

      def add_payment_information
        self.document << Element.new('PaymentInformation').tap do |payment|
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
