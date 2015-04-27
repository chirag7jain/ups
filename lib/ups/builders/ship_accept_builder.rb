require 'ox'

module UPS
  module Builders
    class ShipAcceptBuilder < BuilderBase
      include Ox

      def initialize
        super 'ShipmentAcceptRequest'

        add_request 'ShipAccept', '1'
      end

      def add_shipment_digest(digest)
        self.root << element_with_value('ShipmentDigest', digest)
      end
    end
  end
end
