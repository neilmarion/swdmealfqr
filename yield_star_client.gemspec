# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yield_star_client/version"

Gem::Specification.new do |s|
  s.name        = "yield_star_client"
  s.version     = YieldStarClient::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["G5"]
  s.email       = ["engineering@g5platform.com"]
  s.homepage    = "http://rubygems.org/gems/yield_star_client"
  s.summary     = %q{Adapter for YieldStar AppExchange}
  s.description = %q{A simple wrapper around a SOAP client for the YieldStar AppExchange web service.}

  s.rubyforge_project = "yield_star_client"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('configlet', '~> 2.1')
  s.add_dependency('savon', '0.9.7')
  s.add_dependency('modelish', '>= 0.1.2')

  s.add_development_dependency('rspec','~> 2.4')
  s.add_development_dependency('webmock', '~> 1.6')
  s.add_development_dependency('yard', '~> 0.6')
  s.add_development_dependency('rdiscount', '~>1.6')
  s.add_development_dependency('gyoku', '0.4.4')
  s.add_development_dependency('savon_spec','~> 0.1')
  s.has_rdoc=true
end
