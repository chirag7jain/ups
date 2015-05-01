require 'ox'

module UPS
  module Builders
    class ShipConfirmBuilder < BuilderBase
      include Ox

      attr_accessor :root, :shipment_root

      def initialize
        super 'ShipmentConfirmRequest'

        add_request 'ShipConfirm', 'validate'
        add_label_specification
      end

      def add_label_specification
        root << Element.new('LabelSpecification').tap do |label_spec|
          label_spec << label_print_method
          label_spec << element_with_value('HTTPUserAgent', version_string)
          label_spec << label_image_format
        end
      end

      def add_service(service_code, service_description = '')
        shipment_root << Element.new('Service').tap do |service|
          service << element_with_value('Code', service_code)
          service << element_with_value('Description', service_description)
        end
      end

      private

      def version_string
        "RubyUPS/#{UPS::Version::STRING}"
      end

      def label_print_method
        Element.new('LabelPrintMethod').tap do |label_print_method|
          label_print_method << element_with_value('Code', 'GIF')
          label_print_method << element_with_value('Description', 'gif file')
        end
      end

      def label_image_format
        Element.new('LabelImageFormat').tap do |label_image_format|
          label_image_format << element_with_value('Code', 'GIF')
          label_image_format << element_with_value('Description', 'gif')
        end
      end
    end
  end
end
