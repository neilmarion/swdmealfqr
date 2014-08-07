module YieldStarClient
  module PropertyMethods
    include YieldStarClient::Validations

    # Retrieves all properties for a client.
    #
    # @return [Array<YieldStarClient::Property>] list of properties
    #
    # @raise [ArgumentError] when client_name is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_properties
      response = GetProperties::Request.execute(default_savon_params)
      GetProperties::Response.new(response).properties
    end

    # Retrieves information for a specific property.
    #
    # @param [String] external_property_id the ID of the property to obtain information for
    # @return [YieldStarClient::Property] the property data
    #
    # @raise [ArgumentError] when external_property_id or client_name are missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_property(external_property_id)
      response = GetProperty::Request.execute(
        default_savon_params.merge(external_property_id: external_property_id)
      )
      GetProperty::Response.new(response).property
    end


    # Retrieves pricing parameters for a specific property.
    #
    # @param [String] external_property_id the ID of the property to obtain information for
    # @return [YieldStarClient::PropertyParameters] the pricing data
    #
    # @raise [ArgumentError] when external_property_id or client_name are missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_property_parameters(external_property_id)
      response = GetPropertyParameters::Request.execute(
        default_savon_params.merge(external_property_id: external_property_id)
      )
      GetPropertyParameters::Response.new(response).property_parameters
    end
  end
end
