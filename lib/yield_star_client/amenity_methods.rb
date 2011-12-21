require 'yield_star_client/validations'
require 'modelish'

module YieldStarClient
  # Represents a YieldStar amenity.
  #
  # All amenities are guaranteed to have a +name+ and +type+; +value+ is optional.
  #
  # @attr [String] name the name of the amenity
  # @attr [String] type the type of the amenity
  # @attr [Float[ value the value of the amenity
  class Amenity < Modelish::Base
    property :name
    property :type
    property :value, :type => Float
  end

  module AmenityMethods
    include Validations

    # Retrieves all of the amenities associated with a specific floor plan.
    #
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
    def get_floor_plan_amenities(external_property_id, floor_plan_name)
      validate_external_property_id!(external_property_id)
      validate_required!(:floor_plan_name => floor_plan_name)

      response = send_soap_request(:get_floor_plan_amenities, :external_property_id => external_property_id, 
                                                              :floor_plan_name => floor_plan_name)

      amenities = response.to_hash[:get_floor_plan_amenities_response][:return][:amenity] || []
      [amenities].flatten.collect { |a| Amenity.new(a) }
    end

    # Retrieves all of the amenities associated with a specific unit.
    #
    # @param [String] external_property_id the ID of the property where the floor plan is located
    # @param [String] unit_name the name of the unit
    # @param [optional,String] building the name of the building where the unit is located
    #
    # @return [Array<YieldStarClient::Amenity>] list of unit amenities
    #
    # @raise [ArgumentError] when a required argument is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_unit_amenities(external_property_id, unit_name, building=nil)
      validate_external_property_id!(external_property_id)
      validate_required!(:unit_name => unit_name)

      body = {:external_property_id => external_property_id,
              :unit_name => unit_name}
      body[:building] = building if building

      response = send_soap_request(:get_unit_amenities, body)

      amenities = response.to_hash[:get_unit_amenities_response][:return][:amenity] || []
      [amenities].flatten.collect { |a| Amenity.new(a) }
    end
  end
end
