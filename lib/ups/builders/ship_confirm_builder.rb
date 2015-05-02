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
        shipment_root << code_description('Service',
                                          service_code,
                                          service_description)
      end

      private

      def version_string
        "RubyUPS/#{UPS::Version::STRING}"
      end

      def label_print_method
        code_description 'LabelPrintMethod', 'GIF', 'gif file'
      end

      def label_image_format
        code_description 'LabelImageFormat', 'GIF', 'gif'
      end
    end
  end
end
