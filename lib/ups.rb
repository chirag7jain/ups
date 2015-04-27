module UPS
  autoload :VERSION,              'ups/version'
  autoload :SERVICES,             'ups/services'

  autoload :Connection,           'ups/connection'
  autoload :Exceptions,           'ups/exceptions'

  module Parsers
    autoload :ParserBase,         'ups/parsers/parser_base'
    autoload :RatesParser,        'ups/parsers/rates_parser'
    autoload :ShipConfirmParser,  'ups/parsers/ship_confirm_parser'
    autoload :ShipAcceptParser,   'ups/parsers/ship_accept_parser'
  end

  module Builders
    autoload :BuilderBase,        'ups/builders/builder_base'
    autoload :RateBuilder,        'ups/builders/rate_builder'
    autoload :AddressBuilder,     'ups/builders/address_builder'
    autoload :ShipConfirmBuilder, 'ups/builders/ship_confirm_builder'
    autoload :ShipAcceptBuilder,  'ups/builders/ship_accept_builder'
  end
end
