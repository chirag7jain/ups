# frozen_string_literal: true
require File.expand_path('../lib/ups/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name        = 'ups'
  spec.version     = UPS::Version::STRING
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ['Paul Trippett']
  spec.email       = ['paul@trippett.org']
  spec.homepage    = 'http://github.com/ptrippett/ups'
  spec.summary     = 'UPS'
  spec.description = 'UPS Gem for accessing the UPS API from Ruby'

  spec.license     = 'AGPL'

  spec.required_rubygems_version = '>= 1.3.6'

  spec.add_runtime_dependency 'ox', '<= 2.6.0'
  spec.add_runtime_dependency 'typhoeus', '~> 1.0.0'
  spec.add_runtime_dependency 'insensitive_hash', '~> 0.3.3'
  spec.add_runtime_dependency 'levenshtein-ffi', '~> 1.1'

  spec.add_development_dependency 'simplecov', '~> 0.15.0'
  spec.add_development_dependency 'simplecov-html', '~> 0.10.2'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_path = 'lib'
end
