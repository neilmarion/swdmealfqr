require "modelish"
require "active_model"
require "virtus"
require "active_support/concern"
require "active_support/core_ext/class/attribute"

require 'yield_star_client/version'
require 'yield_star_client/validations'

require 'yield_star_client/models/amenity'
require 'yield_star_client/models/available_floor_plan'
require 'yield_star_client/models/available_unit'
require 'yield_star_client/models/property'
require 'yield_star_client/models/property_parameters'
require 'yield_star_client/models/unit_rate'
require 'yield_star_client/models/lease_term_rent'
require 'yield_star_client/models/renewal_lease_term_rent'
require 'yield_star_client/models/rent_summary'
require 'yield_star_client/models/lease_term_rent_options'
require 'yield_star_client/models/unit'
require 'yield_star_client/models/floor_plan'

require "yield_star_client/extract_rent_summary_hashes"

require 'yield_star_client/configuration'

module YieldStarClient
  extend Configuration

  require 'yield_star_client/client'
end
