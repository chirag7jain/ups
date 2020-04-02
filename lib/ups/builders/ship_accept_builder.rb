# frozen_string_literal: true

require 'ox'

module UPS
  module Builders
    # The {ShipAcceptBuilder} class builds UPS XML ShipAccept Objects.
    #
    # @author Paul Trippett
    # @since 0.1.0
    class ShipAcceptBuilder < BuilderBase
      include Ox

      # Initializes a new {ShipAcceptBuilder} object
      #
      def initialize
        super 'ShipmentAcceptRequest'

        add_request 'ShipAccept', '1'
      end

      # Adds a ShipmentDigest section to the XML document being built
      #
      # @param [String] digest The UPS Shipment Digest returned from the
      #   ShipConfirm request
      # @return [void]
      def add_shipment_digest(digest)
        root << element_with_value('ShipmentDigest', digest)
      end
    end
  end
end
