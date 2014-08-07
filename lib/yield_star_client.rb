require "modelish"
require "active_model"
require "virtus"

require 'yield_star_client/version'
require 'yield_star_client/validations'

require 'yield_star_client/models/property'
require 'yield_star_client/models/property_parameters'
require 'yield_star_client/models/unit_rate'
require 'yield_star_client/models/lease_term_rent'
require 'yield_star_client/models/renewal_lease_term_rent'
require 'yield_star_client/models/lease_term_rent_options'

require 'yield_star_client/configuration'

module YieldStarClient
  extend Configuration

  require 'yield_star_client/client'
end
