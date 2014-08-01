require 'bundler'
Bundler.require :default, :development
require "savon/mock/spec_helper"

Dir[File.join(File.dirname(__FILE__), 'support', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include WebMock::API
  config.include Savon::SpecHelper
end

require 'yield_star_client'
