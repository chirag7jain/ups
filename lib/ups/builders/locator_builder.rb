# frozen_string_literal: true

require 'ox'

module UPS
  module Builders
    # The {TrackingBuilder} class builds UPS XML Track Objects.
    #
    class LocatorBuilder < BuilderBase
      include Ox

      # Initializes a new {TrackingBuilder} object
      #
      def initialize
        super 'LocatorRequest', true

        add_request('Locator', '64')
      end

      def add_location_number(point_id)
        root << Element.new('LocationSearchCriteria').tap do |location|
          location << Element.new('AccessPointSearch').tap do |access_point|
            access_point << element_with_value('PublicAccessPointID', point_id)
          end
        end
        # root << element_with_value('LocationID', location_number)
      end

      def add_origin_country(country = 'US', city = 'Atlanta')
        root << Element.new('OriginAddress').tap do |origin_address|
          origin_address << Element.new('AddressKeyFormat').tap do |address_key|
            address_key << element_with_value('CountryCode', country)
            address_key << element_with_value('PoliticalDivision2', city)
          end
        end
      end

      def add_translation(language_code)
        root << Element.new('Translate').tap do |translate|
          translate << element_with_value('LanguageCode', language_code)
        end
      end

      private

      def initialize_xml_roots(root_name)
        self.document = Document.new
        self.root = Element.new(root_name)
        self.access_request = Element.new('AccessRequest')
        document << instruction
      end
    end
  end
end
