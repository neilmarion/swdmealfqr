require 'yield_star_client'
require 'rspec'
require 'webmock/rspec'

Dir[File.join(File.dirname(__FILE__), 'support', '*.rb')].each { |f| require f }

require 'savon_spec'
Savon::Spec::Fixture.path = File.expand_path("../fixtures", __FILE__)

RSpec.configure do |config|
  config.include WebMock::API
  config.include Savon::Spec::Macros
end

Savon.configure do |config|
  config.log = false
end
