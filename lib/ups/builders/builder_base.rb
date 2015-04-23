require 'ox'

module UPS
  module Builders
    class BuilderBase
      include Ox

      def element_with_value(name, value)
        Element.new('RequestAction').tap do |request_action|
          request_action << Node.new(value)
        end
      end
    end
  end
end
