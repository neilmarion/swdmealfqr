require 'bundler'
Bundler.require :default, :development
require "savon/mock/spec_helper"
require "active_support/core_ext/hash/indifferent_access"

SPEC_DIR = File.expand_path("../", __FILE__)
CONFIG = YAML.load_file(File.join(SPEC_DIR, "config.yml")).
  with_indifferent_access

Dir[File.join(File.dirname(__FILE__), 'support', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include WebMock::API
  config.include Savon::SpecHelper
end

require 'yield_star_client'
