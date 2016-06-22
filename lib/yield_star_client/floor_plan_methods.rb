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
      floor_plans = get_floor_plans(external_property_id)
      available_floor_plans = get_available_floor_plans(external_property_id)

      names = floor_plans_without_available_units(floor_plans, available_floor_plans)
      available_floor_plans + floor_plan_with_names(floor_plans, names)
    end

    private

    def floor_plan_with_names(floor_plans, names)
      floor_plans.select do |floor_plan|
        names.include? floor_plan.name
      end
    end

    def floor_plans_without_available_units(floor_plans, available_floor_plans)
      floor_plans.map(&:name) - available_floor_plans.map(&:name)
    end

    # Retrieves rental information for all currently available units at a specific
    # property, grouped by floor plan.
    #
    # @param [String] external_property_id the ID of the property where the available
    #                                      units are located
    #
    # @return [Array<YieldStarClient::AvailableFloorPlan>] list of floor plans with
    #                                                      available units
    #
    # @raise [ArgumentError] when a required argument is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_available_floor_plans(external_property_id)
      request_args = default_savon_params.
        merge(external_property_id: external_property_id)
      response = GetAvailableUnits::Request.execute(request_args)
      GetAvailableUnits::Response.new(response).available_floor_plans
    end
  end
end
