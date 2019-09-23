# frozen_string_literal: true
require 'base64'
require 'tempfile'

module UPS
  module Parsers
    class ShipAcceptParser < ParserBase
      attr_accessor :graphic_image,
                    :graphic_extension,
                    :html_image,
                    :tracking_number,
                    :graphic_images,
                    :graphic_extensions,
                    :html_images,
                    :tracking_numbers

      def initialize
        super
        @graphic_images = []
        @graphic_extensions = []
        @html_images = []
        @tracking_numbers = []
      end

      def value(value)
        parse_graphic_image(value)
        parse_html_image(value)
        parse_tracking_number(value)
        parse_graphic_extension(value)
        super
      end

      def parse_graphic_image(value)
        return unless switch_active?(:GraphicImage)
        self.graphic_image = base64_to_file(value.as_s)
        self.graphic_images << graphic_image
      end

      def parse_html_image(value)
        return unless switch_active?(:HTMLImage)
        self.html_image = base64_to_file(value.as_s)
        self.html_images << html_image
      end

      def parse_tracking_number(value)
        return unless switch_active?(:ShipmentIdentificationNumber)
        self.tracking_number = value.as_s
        self.tracking_numbers << tracking_number
      end

      def parse_graphic_extension(value)
        return unless switch_active?(:LabelImageFormat, :Code)
        self.graphic_extension = ".#{value.as_s.downcase}"
        self.graphic_extensions << graphic_extension
      end

      def base64_to_file(contents)
        file_config = ['ups', graphic_extension]
        Tempfile.new(file_config, nil, encoding: 'ascii-8bit').tap do |file|
          begin
            file.write Base64.decode64(contents)
          ensure
            file.rewind
          end
        end
      end
    end
  end
end
