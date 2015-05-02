require 'ox'

module UPS
  module Builders
    class OrganisationBuilder < BuilderBase
      include Ox

      attr_accessor :name, :opts

      def initialize(name, opts = {})
        self.name = name
        self.opts = opts
      end

      def company_name
        element_with_value('CompanyName', opts[:company_name])
      end

      def phone_number
        element_with_value('PhoneNumber', opts[:phone_number])
      end

      def attention_name
        element_with_value('AttentionName', opts[:company_name])
      end

      def address
        AddressBuilder.new(opts).to_xml
      end

      def to_xml
        Element.new(name).tap do |org|
          org << company_name
          org << phone_number
          org << attention_name
          org << address
        end
      end
    end
  end
end
