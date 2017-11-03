# frozen_string_literal: true
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
      end

      # Adds a LabelSpecification section to the XML document being built
      # according to user inputs
      #
      # @return [void]
      def add_label_specification(format, size)
        root << Element.new('LabelSpecification').tap do |label_spec|
          label_spec << label_print_method(format)
          label_spec << label_image_format(format)
          label_spec << label_stock_size(size)
          label_spec << http_user_agent if gif?(format)
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

      # Adds Description to XML document being built
      #
      # @param [String] description The description for goods being sent
      #
      # @return [void]
      def add_description(description)
        shipment_root << element_with_value('Description', description)
      end

      # Adds Email notification to Shipment/ShipmentServiceOptions/Notification
      #
      # @param [Array] notification_codes => strings, Max length = 3
      # @param [Array] emails => strings, Max lenght = 2
      #
      # @return [void]
      def add_email_notifications(notification_codes, emails)
        add_shipment_service_options
        notification_codes.each do |notif_code|
          add_email_notification notif_code, emails
        end
      end

      private

      attr_accessor :shipment_service_options_root

      def add_email_notification(notif_code, emails)
        notification = Element.new('Notification')
        shipment_service_options_root << notification.tap do |notif_root|
          notif_root << element_with_value('NotificationCode', notif_code)
          notif_root << Element.new('EMailMessage').tap do |msg_root|
            emails.each do |email|
              msg_root << element_with_value('EMailAddress', email)
            end
          end
        end
      end

      def add_shipment_service_options
        return if shipment_service_options_root
        @shipment_service_options_root = Element.new('ShipmentServiceOptions')
        shipment_root << shipment_service_options_root
      end

      def gif?(string)
        string.casecmp('gif').zero?
      end

      def http_user_agent
        element_with_value('HTTPUserAgent', version_string)
      end

      def version_string
        "RubyUPS/#{UPS::Version::STRING}"
      end

      def label_print_method(format)
        code_description 'LabelPrintMethod', format.to_s, "#{format} file"
      end

      def label_image_format(format)
        code_description 'LabelImageFormat', format.to_s, format.to_s
      end

      def label_stock_size(size)
        multi_valued('LabelStockSize',
                     'Height' => size[:height].to_s,
                     'Width' => size[:width].to_s)
      end
    end
  end
end
