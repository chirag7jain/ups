# frozen_string_literal: true

module UPS
  module Exceptions
    class UpsGemException < StandardError; end

    class InvalidUrlException < UpsGemException; end
    class InvalidAttributeError < UpsGemException; end
    class AuthenticationRequiredException < UpsGemException; end
  end
end
