require 'base64'
require 'tempfile'

module UPS
  module Parsers
    class ShipAcceptParser < ParserBase
      attr_accessor :graphic_image, :graphic_extension, :html_image, :tracking_number

      def value(value)
        parse_graphic_image(value) if switch_active?(:GraphicImage)
        parse_html_image(value) if switch_active?(:HTMLImage)
        parse_tracking_number(value) if switch_active?(:ShipmentIdentificationNumber)
        parse_graphic_extension(value) if switch_active?(:LabelImageFormat, :Code)
        super
      end

      def parse_graphic_image(value)
        self.graphic_image = base64_to_file(value.as_s)
      end

      def parse_html_image(value)
        self.html_image = base64_to_file(value.as_s)
      end

      def parse_tracking_number(value)
        self.tracking_number = value.as_s
      end

      def parse_graphic_extension(value)
        self.graphic_extension = ".#{value.as_s.downcase}"
      end

      def base64_to_file(contents)
        Tempfile.new(['ups', self.graphic_extension], nil, :encoding => 'ascii-8bit').tap do |file|
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
