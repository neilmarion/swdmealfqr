require 'validations'
require 'base_model'

module YieldStarClient
  # Represents a YieldStar amenity.
  #
  # All amenities are guaranteed to have a +name+ and +type+; +value+ is optional.
  #
  # @attr [String] name the name of the amenity
  # @attr [String] type the type of the amenity
  # @attr [Float[ value the value of the amenity
  class Amenity < BaseModel
    property :name
    property :type
    property :value, :type => Float
  end

  module AmenityMethods
    # Retrieves all of the amenities associated with a specific floor plan.
    #
    # @param [String] client_name the YieldStar client name
    # @param [String] external_property_id the ID of the property where the floor plan is located
    # @param [String] floor_plan_name the name of the floor plan
    #
    # @return [Array<YieldStarClient::Amenity>] list of amenities
    #
    # @raise [ArgumentError] when a required argument is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_floor_plan_amenities(client_name, external_property_id, floor_plan_name)
      validate_client_name(client_name)
      validate_external_property_id(external_property_id)
      validate_required(:floor_plan_name => floor_plan_name)

      response = send_soap_request(:get_floor_plan_amenities, :client_name => client_name, 
                                                              :external_property_id => external_property_id, 
                                                              :floor_plan_name => floor_plan_name)

      amenities = response.to_hash[:get_floor_plan_amenities_response][:return][:amenity] || []
      [amenities].flatten.collect { |a| Amenity.new(a) }
    end
  end
end
