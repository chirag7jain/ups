require 'levenshtein'

module UPS
  module Data
    class << self
      EMPTY_STATE_MESSAGE = 'Invalid Address State [:state]'

      # Normalizes Irish states as per UPS requirements
      #
      # @param [String] string The Irish State to normalize
      # @return [String] The normalized Irish state name
      def ie_state_normalizer(string)
        string.tap do |target|
          IE_COUNTY_PREFIXES.each do |prefix|
            target.gsub!(/^#{Regexp.escape(prefix.downcase)} /i, '')
          end
        end
      end

      # Returns the closest matching Irish state name. Uses Levenshtein
      # distance to correct any possible spelling errors.
      #
      # @param [String] match_string The Irish State to match
      # @raise [InvalidAttributeError] If the passed match_String is nil or
      #   empty
      # @return [String] The closest matching irish state with the specified
      #   name
      def ie_state_matcher(match_string)
        fail Exceptions::InvalidAttributeError, EMPTY_STATE_MESSAGE if
          match_string.nil? || match_string.empty?

        normalized_string = ie_state_normalizer string_normalizer match_string
        counties_with_distances = IE_COUNTIES.map do |county|
          [county, Levenshtein.distance(county.downcase, normalized_string)]
        end
        counties_with_distances_hash = Hash[*counties_with_distances.flatten]
        counties_with_distances_hash.min_by { |_k, v| v }[0]
      end

      # Removes extra characters from a string
      #
      # @param [String] string The string to normalize and remove special
      #   characters
      # @return [String] The normalized string
      def string_normalizer(string)
        string.downcase.gsub(/[^0-9a-z ]/i, '')
      end
    end
  end
end
