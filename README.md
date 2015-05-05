[![Gem Version](https://img.shields.io/gem/v/ups.svg?style=flat-square)](http://badge.fury.io/rb/ups)
[![Dependency Status](https://img.shields.io/gemnasium/ptrippett/ups.svg?style=flat-square)](https://gemnasium.com/ptrippett/ups)
[![Build Status](https://img.shields.io/travis/ptrippett/ups.svg?style=flat-square)](https://travis-ci.org/ptrippett/ups)
[![Coverage Status](https://img.shields.io/codeclimate/coverage/github/ptrippett/ups.svg?style=flat-square)](https://codeclimate.com/github/ptrippett/ups/coverage)
[![Code Climate](https://img.shields.io/codeclimate/github/ptrippett/ups.svg?style=flat-square)](https://codeclimate.com/github/ptrippett/ups)

# UPS

UPS Gem for accessing the UPS API from Ruby. Using the gem you can:
  - Return quotes from the UPS API
  - Book shipments
  - Return labels and tracking numbers for a shipment

This gem is currently used in production at [Veeqo](http://www.veeqo.com)

## Installation

    gem install ups

...or add it to your project's [Gemfile](http://bundler.io/).

## Sample Usage

### Return rates

    require 'ups'
    server = UPS::Connection.new(test_mode: true)
    response = server.rates do |rate_builder|
      rate_builder.add_access_request 'API_KEY', 'USERNAME', 'PASSWORD'
      rate_builder.add_shipper company_name: 'Veeqo Limited',
        phone_number: '01792 123456',
        address_line_1: '11 Wind Street',
        city: 'Swansea',
        state: 'Wales',
        postal_code: 'SA1 1DA',
        country: 'GB',
        shipper_number: 'ACCOUNT_NUMBER'
      rate_builder.add_ship_from company_name: 'Veeqo Limited',
        phone_number: '01792 123456',
        address_line_1: '11 Wind Street',
        city: 'Swansea',
        state: 'Wales',
        postal_code: 'SA1 1DA',
        country: 'GB',
        shipper_number: ENV['UPS_ACCOUNT_NUMBER']
      rate_builder.add_ship_to company_name: 'Google Inc.',
        phone_number: '0207 031 3000',
        address_line_1: '1 St Giles High Street',
        city: 'London',
        state: 'England',
        postal_code: 'WC2H 8AG',
        country: 'GB'
      rate_builder.add_package weight: '0.5',
        unit: 'KGS'
    end

    # Then use...
    response.success?
    response.graphic_image
    response.tracking_number

## Running the tests

After installing dependencies with `bundle install`, you can run the unit tests using `rspec`.
