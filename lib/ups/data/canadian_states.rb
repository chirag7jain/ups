require 'insensitive_hash'

module UPS
  module Data
    CANADIAN_STATES = {
      'British Columbia' => 'BC',
      'Ontario' => 'ON',
      'Newfoundland and Labrador' => 'NL',
      'Nova Scotia' => 'NS',
      'Prince Edward Island' => 'PE',
      'New Brunswick' => 'NB',
      'Quebec' => 'QC',
      'Manitoba' => 'MB',
      'Saskatchewan' => 'SK',
      'Alberta' => 'AB',
      'Northwest Territories' => 'NT',
      'Nunavut' => 'NU',
      'Yukon Territory' => 'YT'
    }.insensitive
  end
end
