# frozen_string_literal: true
require 'ox'

module UPS
  module Builders
    # The {RateBuilder} class builds UPS XML Rate Objects.
    #
    # @author Paul Trippett
    # @since 0.1.0
    class RateBuilder < BuilderBase
      include Ox

      # Initializes a new {RateBuilder} object
      #
      def initialize
        super 'RatingServiceSelectionRequest'

        add_request('Rate', 'Shop')
      end
    end
  end
end
