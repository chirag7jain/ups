module UPS
  autoload :VERSION,              'ups/version'
  autoload :Connection,           'ups/connection'
  autoload :Exceptions,           'ups/exceptions'

  module Parsers
    autoload :ParserBase,         'ups/parsers/parser_base'
    autoload :RatesParser,        'ups/parsers/rates_parser'
  end

  module Builders
    autoload :BuilderBase,        'ups/builders/builder_base'
    autoload :RateBuilder,        'ups/builders/rate_builder'
    autoload :AddressBuilder,     'ups/builders/address_builder'
  end
end
