require "bundler"
Bundler.setup

require "rake"
require "rspec"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new("spec") do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

Dir.glob('tasks/*.rake').each {|r| import r}

task :default => :spec