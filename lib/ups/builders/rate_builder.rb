require 'ox'

module UPS
  module Builders
    class RateBuilder < BuilderBase
      include Ox

      def initialize
        super 'RatingServiceSelectionRequest'

        add_request('Rate', 'Shop')
      end
    end
  end
end
