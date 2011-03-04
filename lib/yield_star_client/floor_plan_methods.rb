require 'validations'
require 'errors'

module YieldStarClient
  module FloorPlanMethods
    include Validations

    # Retrieves all floor plans for a particular property.
    #
    # @see #get_floor_plan
    #
    # @param [String] client_name the YieldStar client name
    # @param [String] external_property_id the ID of the property
    # @return [Array<Hash>] list of floor plans
    # @raise [ArgumentError] when a parameter is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_floor_plans(client_name, external_property_id)
      validate_client_name(client_name)
      validate_external_property_id(external_property_id)

      begin
        response = soap_client.request :wsdl, :get_floor_plans do
          soap.element_form_default = :qualified
          soap.body = { :client_name => client_name, :external_property_id => external_property_id }
        end

        floor_plans = response.to_hash[:get_floor_plans_response][:return][:floor_plan] || []
        floor_plans = [floor_plans].flatten

        floor_plans.collect { |fp| process_floor_plan(fp) }
      rescue Savon::SOAP::Fault => f
        raise ServerError.translate_fault(f)
      end
    end

    # Retrieves a specific floor plan.
    #
    # A floor plan is guaranteed to have the following data:
    # <b>+:external_property_id+</b>:: the property ID of this floor plan +(String)+
    # <b>+:name+</b>:: the name of this floor plan +(String)+
    #
    # Additionally, the floor plan may have the following optional fields:
    # <b>+:description+</b>:: the description of this floor plan +(String)+
    # <b>+:square_footage+</b>:: the average square footage of this floor plan +(Integer)+
    # <b>+:unit_count+</b>:: the number of units with this floor plan +(Integer)+
    # <b>+bed_rooms+</b>::the bedroom count of the floor plan +(Float)+
    # <b>+bath_rooms+</b>:: the bathroom count of the floor plan +(Float)+
    #
    # @param [String] client_name the YieldStar client name
    # @param [String] external_property_id the ID of the property
    # @param [String] floor_plan_name the name of the floor plan
    # @return [Hash] the floor plan data
    # @raise [ArgumentError] when a parameter is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_floor_plan(client_name, external_property_id, floor_plan_name)
      validate_client_name(client_name)
      validate_external_property_id(external_property_id)
      validate_required(:floor_plan_name, floor_plan_name)

      begin
        response = soap_client.request :wsdl, :get_floor_plan do
          soap.element_form_default = :qualified
          soap.body = {:client_name => client_name, :external_property_id => external_property_id, :name => floor_plan_name}
        end

        floor_plan = response.to_hash[:get_floor_plan_response][:return][:floor_plan]

        process_floor_plan(floor_plan)
      rescue Savon::SOAP::Fault => f
        raise ServerError.translate_fault(f)
      end
    end

    private
    def process_floor_plan(floor_plan)
      # TODO: better solution for type conversion
      [:square_footage, :unit_count].each { |k| floor_plan[k] = floor_plan[k].to_i if floor_plan.has_key?(k) }
      [:bed_rooms, :bath_rooms].each { |k| floor_plan[k] = floor_plan[k].to_f if floor_plan.has_key?(k) }
      floor_plan
    end
  end
end
