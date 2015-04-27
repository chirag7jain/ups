require 'base64'
require 'tempfile'

module UPS
  module Parsers
    class ShipAcceptParser < ParserBase
      attr_accessor :graphic_image, :graphic_extension, :html_image, :tracking_number

      def value(value)
        if switch_active?(:GraphicImage)
          self.graphic_image = base64_to_file(value.as_s)
        elsif switch_active?(:HTMLImage)
          self.html_image = base64_to_file(value.as_s)
        elsif switch_active?(:ShipmentIdentificationNumber)
          self.tracking_number = value.as_s
        elsif switch_active?(:LabelImageFormat) && switch_active?(:Code)
          self.graphic_extension = ".#{value.as_s.downcase}"
        end
        super
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
