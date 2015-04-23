module UPS
  module Exceptions
    class InvalidUrlException < StandardError; end
    class AuthenticationRequiredException < StandardError; end
  end
end
