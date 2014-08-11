require 'yield_star_client/validations'
require 'modelish'

module YieldStarClient
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
      request_args = default_savon_params.merge(
        external_property_id: external_property_id,
        floor_plan_name: floor_plan_name,
      )
      response = GetFloorPlanAmenities::Request.execute(request_args)
      GetFloorPlanAmenities::Response.new(response).amenities
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
      request_args = default_savon_params.merge(
        external_property_id: external_property_id,
        unit_name: unit_name,
        building: building,
      )
      response = GetUnitAmenities::Request.execute(request_args)
      GetUnitAmenities::Response.new(response).amenities
    end
  end
end
