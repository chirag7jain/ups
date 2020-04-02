# frozen_string_literal: true

require 'ox'

module UPS
  module Builders
    # The {LocatorBuilder} class builds UPS XML Locator Objects.
    #
    class LocatorBuilder < BuilderBase
      include Ox

      # Initializes a new {LocatorBuilder} object
      #
      def initialize(test_mode)
        super 'LocatorRequest', true

        @test_mode = test_mode
        add_request('Locator', '64')
      end

      def add_location_number(point_id)
        root << Element.new('LocationSearchCriteria').tap do |location|
          location << Element.new('AccessPointSearch').tap do |access_point|
            access_point << element_with_value('PublicAccessPointID', point_id)
          end
        end
      end

      def add_origin_country(country)
        root << Element.new('OriginAddress').tap do |origin_address|
          origin_address << Element.new('AddressKeyFormat').tap do |address_key|
            add_address_elements address_key, country
          end
        end
      end

      def add_translation(language_code)
        root << Element.new('Translate').tap do |translate|
          translate << element_with_value('LanguageCode', language_code)
        end
      end

      private

      def add_address_elements(address_key, country)
        return add_test_address_elements address_key if @test_mode
        add_prod_address_elements address_key, country
      end

      def add_prod_address_elements(address_key, country)
        address_key << element_with_value('CountryCode', country)
      end

      def add_test_address_elements(address_key)
        address_key << element_with_value('CountryCode', 'US')
        address_key << element_with_value('PoliticalDivision2', 'Atlanta')
      end

      def initialize_xml_roots(root_name)
        self.document = Document.new
        self.root = Element.new(root_name)
        self.access_request = Element.new('AccessRequest')
        document << instruction
      end
    end
  end
end
