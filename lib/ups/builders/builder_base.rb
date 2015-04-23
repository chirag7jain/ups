require 'ox'

module UPS
  module Builders
    class BuilderBase
      include Ox
      include UPS::Exceptions

      attr_accessor :document, :root

      def initialize
        self.document = Document.new
      end

      def add_access_request license_number, user_id, password
        self.document << Element.new('AccessRequest').tap do |access_request|
          access_request << element_with_value('AccessLicenseNumber', license_number)
          access_request << element_with_value('UserId', user_id)
          access_request << element_with_value('Password', password)
        end
      end

      def element_with_value(name, value)
        raise InvalidAttributeError.new unless value.respond_to?(:to_str)
        Element.new(name).tap do |request_action|
          request_action << value.to_str
        end
      end

      def to_xml
        Ox.to_xml self.document
      end
    end
  end
end
