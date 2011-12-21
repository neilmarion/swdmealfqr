require 'bundler'
Bundler.require :default, :development

Dir[File.join(File.dirname(__FILE__), 'support', '*.rb')].each { |f| require f }

Savon::Spec::Fixture.path = File.expand_path("../fixtures", __FILE__)

RSpec.configure do |config|
  config.include WebMock::API
  config.include Savon::Spec::Macros
end

require 'yield_star_client'
