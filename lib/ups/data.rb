require 'levenshtein'

module UPS
  module Data
    class << self
      def ie_state_normalizer(string)
        string.tap do |target|
          IE_COUNTY_PREFIXES.each do |prefix|
            target.gsub!(/^#{Regexp.escape(prefix.downcase)} /i, '')
          end
        end
      end

      def ie_state_matcher(match_string)
        normalized_string = ie_state_normalizer string_normalizer match_string
        counties_with_distances = IE_COUNTIES.map do |county|
          [county, Levenshtein.distance(county.downcase, normalized_string)]
        end
        counties_with_distances.to_h.min_by { |_k, v| v }[0]
      end

      def string_normalizer(string)
        string.downcase.gsub(/[^0-9a-z ]/i, '')
      end
    end
  end
end
