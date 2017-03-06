require File.expand_path('../lib/ups/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'ups'
  gem.version     = UPS::Version::STRING
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ['Paul Trippett']
  gem.email       = ['paul@trippett.org']
  gem.homepage    = 'http://github.com/ptrippett/ups'
  gem.summary     = 'UPS'
  gem.description = 'UPS Gem for accessing the UPS API from Ruby'

  gem.license     = 'AGPL'

  gem.required_rubygems_version = '>= 1.3.6'

  gem.add_runtime_dependency 'ox', '>= 2.2', '<= 2.4.0'
  gem.add_runtime_dependency 'typhoeus', '~> 1.0.0'
  gem.add_runtime_dependency 'insensitive_hash', '~> 0.3.3'
  gem.add_runtime_dependency 'levenshtein-ffi', '~> 1.1'

  gem.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  gem.require_path = 'lib'
end
