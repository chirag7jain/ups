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
        self.root << Element.new('LabelSpecification').tap do |label_spec|
          label_spec << Element.new('LabelPrintMethod').tap do |label_print_method|
            label_print_method << element_with_value('Code', 'GIF')
            label_print_method << element_with_value('Description', 'gif file')
          end
          label_spec << element_with_value('HTTPUserAgent', "RubyUPS/#{UPS::Version::STRING}")
          label_spec << Element.new('LabelImageFormat').tap do |label_image_format|
            label_image_format << element_with_value('Code', 'GIF')
            label_image_format << element_with_value('Description', 'gif')
          end
        end
      end

      def add_service service_code, service_description = ''
        self.shipment_root << Element.new('Service').tap do |service|
          service << element_with_value('Code', service_code)
          service << element_with_value('Description', service_description)
        end
      end
    end
  end
end
