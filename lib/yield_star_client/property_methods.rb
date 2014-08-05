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
      validate_external_property_id!(external_property_id)

      response = send_soap_request(:get_property, :external_property_id => external_property_id)

      property = response.to_hash[:get_property_response][:return][:property]
      Property.new(property)
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
      validate_external_property_id!(external_property_id)

      response = send_soap_request(:get_property_parameters, :external_property_id => external_property_id)

      response_hash = response.to_hash[:get_property_parameters_response][:return]
      param_hash = { :external_property_id => response_hash[:external_property_id] }
      params = [response_hash[:parameter]].flatten

      unless params.first.nil?
        params.each do |param|
          name = param[:name].downcase.gsub(/(max|min)imum/, '\1').gsub(/\s+/, '_').to_sym
          param_hash[name] = param[:value]
        end
      end

      PropertyParameters.new(param_hash)
    end
  end
end
