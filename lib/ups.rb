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

  SERVICES = {
    "01" => "Next Day Air",
    "02" => "2nd Day Air",
    "03" => "Ground",
    "07" => "Express",
    "08" => "Expedited",
    "11" => "UPS Standard",
    "12" => "3 Day Select",
    "13" => "Next Day Air Saver",
    "14" => "Next Day Air Early AM",
    "54" => "Express Plus",
    "59" => "2nd Day Air A.M.",
    "65" => "UPS Saver",
    "82" => "UPS Today Standard",
    "83" => "UPS Today Dedicated Courier",
    "84" => "UPS Today Intercity",
    "85" => "UPS Today Express",
    "86" => "UPS Today Express Saver"
  }
end
