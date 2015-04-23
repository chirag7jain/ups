require File.expand_path('../lib/ups/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "ups"
  gem.version     = UPS::Version::STRING
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ["Paul Trippett"]
  gem.email       = ["paul@veeqo.com"]
  gem.homepage    = "http://github.com/ptrippett/ups"
  gem.summary     = "UPS"
  gem.description = "UPS Gem for accessing the UPS API from Ruby"

  gem.license     = "AGPL"

  gem.required_rubygems_version = ">= 1.3.6"

  gem.add_runtime_dependency 'ox', '~> 2.2', '>= 2.2.0'
  gem.add_runtime_dependency 'excon', '~> 0.45', '>= 0.45.3'

  gem.files        = `git ls-files`.split($\)
  gem.require_path = "lib"
end
