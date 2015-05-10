require 'ox'

module UPS
  module Builders
    # The {ShipConfirmBuilder} class builds UPS XML ShipConfirm Objects.
    #
    # @author Paul Trippett
    # @since 0.1.0
    # @attr [String] name The Containing XML Element Name
    # @attr [Hash] opts The Organization and Address Parts
    class ShipConfirmBuilder < BuilderBase
      include Ox

      # Initializes a new {ShipConfirmBuilder} object
      #
      def initialize
        super 'ShipmentConfirmRequest'

        add_request 'ShipConfirm', 'validate'
        add_label_specification
      end

      # Adds a LabelSpecification section to the XML document being built
      #
      # @return [void]
      def add_label_specification
        root << Element.new('LabelSpecification').tap do |label_spec|
          label_spec << label_print_method
          label_spec << element_with_value('HTTPUserAgent', version_string)
          label_spec << label_image_format
        end
      end

      # Adds a Service section to the XML document being built
      #
      # @param [String] service_code The Service code for the choosen Shipping
      #   method
      # @param [optional, String] service_description A description for the
      #   choosen Shipping Method
      # @return [void]
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
