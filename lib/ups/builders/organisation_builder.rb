# frozen_string_literal: true
require 'ox'

module UPS
  module Builders
    # The {OrganisationBuilder} class builds UPS XML Organization Objects.
    #
    # @author Paul Trippett
    # @since 0.1.0
    # @attr [String] name The Containing XML Element Name
    # @attr [Hash] opts The Organization and Address Parts
    class OrganisationBuilder < BuilderBase
      include Ox

      attr_accessor :name, :opts

      # Initializes a new {AddressBuilder} object
      #
      # @param [Hash] opts The Organization and Address Parts
      # @option opts [String] :company_name Company Name
      # @option opts [String] :phone_number Phone Number
      # @option opts [String] :address_line_1 Address Line 1
      # @option opts [String] :city City
      # @option opts [String] :state State
      # @option opts [String] :postal_code Zip or Postal Code
      # @option opts [String] :country Country
      def initialize(name, opts = {})
        self.name = name
        self.opts = opts
      end

      # Returns an XML representation of company_name
      #
      # @return [Ox::Element] XML representation of company_name
      def company_name
        company_name_element 'CompanyName'
      end

      def retail_name
        company_name_element('Name')
      end

      def company_name_element(element_name)
        element_with_value(element_name, opts[:company_name][0..34])
      end

      # Returns an XML representation of phone_number
      #
      # @return [Ox::Element] XML representation of phone_number
      def phone_number
        element_with_value('PhoneNumber', opts[:phone_number][0..14])
      end

      # Returns an XML representation of AttentionName for which we use company
      # name
      #
      # @return [Ox::Element] XML representation of company_name part
      def attention_name
        element_with_value('AttentionName', opts[:attention_name][0..34])
      end

      # Returns an XML representation of UPSAccessPointID for which we use
      # ups_access_point_id
      #
      # @return [Ox::Element] XML representation of UPSAccessPointID part
      def ups_access_point_id
        element_with_value('UPSAccessPointID', raw_ups_access_point_id)
      end

      def raw_ups_access_point_id
        opts[:ups_access_point_id]
      end

      # Returns an XML representation of address
      #
      # @return [Ox::Element] An instance of {AddressBuilder} containing the
      #   address
      def address
        AddressBuilder.new(opts).to_xml
      end

      # Returns an XML representation of a UPS Organization
      #
      # @return [Ox::Element] XML representation of the current object
      def to_xml
        Element.new(name).tap do |org|
          if raw_ups_access_point_id
            process_access_point org
          else
            process_regular_org org
          end
          org << attention_name
          org << address
        end
      end

      def process_access_point(org)
        org << ups_access_point_id
        org << retail_name
      end

      def process_regular_org(org)
        org << company_name
        org << phone_number
      end
    end
  end
end
