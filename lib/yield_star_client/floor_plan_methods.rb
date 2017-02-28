require 'yield_star_client/validations'
require 'modelish'

module YieldStarClient
  module FloorPlanMethods
    include YieldStarClient::Validations

    # Retrieves all floor plans for a particular property.
    #
    # @param [String] external_property_id the ID of the property
    # @return [Array<YieldStarClient::FloorPlan>] list of floor plans
    #
    # @raise [ArgumentError] when client_name or external_property_id is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_floor_plans(external_property_id)
      request_args = default_savon_params.merge(
        external_property_id: external_property_id,
      )
      response = GetFloorPlans::Request.execute(request_args)
      GetFloorPlans::Response.new(response).floor_plans
    end

    # Retrieves a specific floor plan.
    #
    # @param [String] external_property_id the ID of the property
    # @param [String] floor_plan_name the name of the floor plan
    # @return [YieldStarClient::FloorPlan] the floor plan data
    #
    # @raise [ArgumentError] when a parameter is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_floor_plan(external_property_id, floor_plan_name)
      request_args = default_savon_params.merge(
        external_property_id: external_property_id,
        floor_plan_name: floor_plan_name,
      )
      response = GetFloorPlan::Request.execute(request_args)
      GetFloorPlan::Response.new(response).floor_plan
    end

    def get_floor_plans_with_units(external_property_id)
      request_args = default_savon_params.merge(
        external_property_id: external_property_id
      )

      response = GetRentSummary::Request.execute(request_args)

      floor_plans = GetRentSummary::Response.new(response)
        .rent_summaries_as_floor_plans

      available_units = get_available_units(external_property_id)

      floor_plans.map do |floor_plan|
        floor_plan.units = available_units.select do |unit|
          unit.unit_type == floor_plan.id
        end
      end.flatten

      floor_plans
    end

    private

    def get_available_units(external_property_id)
      request_args = default_savon_params.
        merge(external_property_id: external_property_id)

      response = GetAvailableUnits::Request.execute(request_args)

      GetAvailableUnits::Response.new(response)
        .available_units
    end
  end
end
