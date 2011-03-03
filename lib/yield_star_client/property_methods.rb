module YieldStarClient
  module PropertyMethods
    # Returns all properties for a client.
    #
    # @see #get_property
    #
    # @param [String] client_name the YieldStar client name
    # @return [Array<Hash>] list of properties 
    # @raise [ArgumentError] when client_name is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_properties(client_name)
      validate_argument(:client_name, client_name, 16)

      begin
        response = soap_client.request :wsdl, :get_properties do
          soap.element_form_default = :qualified
          soap.body = {:request => {:client_name => client_name}}
        end

        properties = [response.to_hash[:get_properties_response][:return][:property]].flatten
        properties.collect{ |prop| process_property(prop) }
      rescue Savon::SOAP::Fault => f
        handle_fault(f)
      end 
    end

    # Returns information for a specific property.
    #
    # A property is guaranteed to have the following attributes:
    #
    # <b>+:external_property_id+</b>:: the property ID +(String)+
    # <b>+:name+</b>:: the property name +(String)+
    #
    # Additionally, the property may have the following optional attributes:
    #
    # <b>+:address+</b>:: the street address +(String)+
    # <b>+:city+</b>:: the city in which the property is located +(String)+
    # <b>+:state+</b>:: the two-letter code of the state in which the property is located +(String)+
    # <b>+:zip+</b>:: the zip code +(String)+
    # <b>+:fax+</b>:: the fax telephone number +(String)+
    # <b>+:phone+</b>:: the voice telephone number +(String)+
    # <b>+:latitude+</b>:: the latitude of the property's location +(Float)+
    # <b>+:longitude+</b>:: the longitude of the property's location +(Float)+
    # <b>+:unit_count+</b>:: the number of units at this property +(Integer)+
    # <b>+:website+</b>:: the URL of the property website +(String)+
    # <b>+:year_built+</b>:: the year in which the property was built +(Integer)+
    #
    # @param [String] client_name the name of the client to perform the request for
    # @param [String] external_property_id the ID of the property to obtain information for
    # @returns [Hash] the property data
    # @raise [ArgumentError] when external_property_id or client_name are missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_property(client_name, external_property_id)
      validate_argument(:client_name, client_name, 16)
      validate_argument(:external_property_id, external_property_id, 50)

      begin
        response = soap_client.request :wsdl, :get_property do
          soap.element_form_default = :qualified
          soap.body = {:client_name => client_name, :external_property_id => external_property_id}
        end

        property = response.to_hash[:get_property_response][:return][:property]
        process_property(property)
      rescue Savon::SOAP::Fault => f
        handle_fault(f)
      end
    end

    private
    def handle_fault(soap_error)
      # TODO: Refactor somewhere shared. (probably into YieldStarClient::ServerError)
      # This logic is going to be the same for most of the soap actions.
      fault = soap_error.to_hash[:fault]
      fault_detail = {}

      if detail = fault[:detail]
        if detail.has_key?(:authentication_fault)
          error_class = YieldStarClient::AuthenticationError
          fault_detail = detail[:authentication_fault]
        elsif detail.has_key?(:operation_fault)
          error_class = YieldStarClient::OperationError
          fault_detail = detail[:operation_fault]
        elsif detail.has_key?(:internal_error_fault)
          error_class = YieldStarClient::InternalError
          fault_detail = detail[:internal_error_fault]
        end
      end

      error_code = fault_detail[:code] || fault[:faultcode]
      error_message = fault_detail[:message] || fault[:faultstring]
      error_class ||= YieldStarClient::ServerError

      raise error_class.new(error_message, error_code)
    end

    # TODO: validations framework - find one or build one
    def validate_argument(name, value, max_length)
      raise ArgumentError.new("#{name} must not be blank") if value.nil? || value.strip.empty?
      raise ArgumentError.new("#{name} must be 16 characters or less") if value.length > max_length
    end

    def process_property(prop_hash)
      convert_types(prop_hash, [:unit_count, :year_built]) { |val| val.to_i }
      convert_types(prop_hash, [:longitude, :latitude]) { |val| val.to_f }
      prop_hash
    end

    # TODO: refactor this somewhere it can be shared. Or find an open-source project where someone else
    # did it better.
    def convert_types(hash, keys, &block)
      keys.each { |k| hash[k] = yield hash[k] if hash.has_key?(k) }
      hash
    end
  end
end
