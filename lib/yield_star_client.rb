require "modelish"
require "active_model"

require 'yield_star_client/version'
require 'yield_star_client/validations'

require 'yield_star_client/models/property'
require 'yield_star_client/models/property_parameters'

require 'yield_star_client/configuration'

module YieldStarClient
  extend Configuration

  require 'yield_star_client/client'
end
