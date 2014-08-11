require 'yield_star_client/validations'
require 'modelish'

module YieldStarClient
  module UnitMethods
    include Validations
    # Retrieves data about a specific unit.
    #
    # @param [String] external_property_id the ID of the property where the unit is located
    # @param [String] unit_name the name of the unit to retrieve
    # @param [optional,String] building_name the name of the building in which the unit is located
    #
    # @return [YieldStarClient::Unit] the unit data
    #
    # @raise [ArgumentError] when a required argument is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_unit(external_property_id, unit_name, building_name=nil)
      validate_external_property_id!(external_property_id)
      validate_required!(:unit_name => unit_name)

      body = {:external_property_id => external_property_id, :name => unit_name}
      body[:building] = building_name if building_name

      response = send_soap_request(:get_unit, body)
      # request_args = {
      #   external_property_id: external_property_id,
      #   name: unit_name,
      #   # building: building,
      # }
      # response = GetUnit::Request.new(request_args)

      unit = response.to_hash[:get_unit_response][:return][:unit]

      Unit.new(unit)
    end

    # Retrieves all units for a specific property, optionally filtered by floor plan.
    #
    # @param [optional,String] floor_plan_name the name of the floor plan associated with the units
    # 
    # @return [Array<Unit>] a list of unit data
    #
    # @raise [ArgumentError] when a required argument is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_units(external_property_id, floor_plan_name=nil)
      request_args = default_savon_params.merge(
        external_property_id: external_property_id,
        floor_plan_name: floor_plan_name,
      )
      response = GetUnits::Request.execute(request_args)
      GetUnits::Response.new(response).units
    end
  end
end
