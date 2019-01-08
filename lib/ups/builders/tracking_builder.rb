# frozen_string_literal: true

require 'ox'

module UPS
  module Builders
    # The {TrackingBuilder} class builds UPS XML Track Objects.
    #
    class TrackingBuilder < BuilderBase
      include Ox

      # Initializes a new {TrackingBuilder} object
      #
      def initialize
        super 'TrackRequest'
      end

      def add_tracking_number(tracking_number)
        root << element_with_value('TrackingNumber', tracking_number)
      end

      private

      def initialize_xml_roots(root_name)
        self.document = Document.new
        self.root = Element.new(root_name)
        self.access_request = Element.new('AccessRequest')
      end
    end
  end
end
