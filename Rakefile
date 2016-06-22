require 'gemfury_helpers'
GemfuryHelpers::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Open irb with yield_star_client preloaded"
task :console do
  sh "irb -rubygems -I lib -r yield_star_client.rb"
end
