module YieldStarClient
  module PropertyMethods
    # Returns all properties for a client.
    #
    # @param [String] client_name the YieldStar client name
    # @return [Array<Hash>] list of properties 
    # @raise ArgumentError when client_name is missing or invalid
    # @raise YieldStarClient::AuthenticationError when unable to authenticate to the web service
    # @raise YieldStarClient::OperationError when the service raises an OperationError fault
    # @raise YieldStarClient::InternalError when the service raises an InternalError fault
    # @raise YieldStarClient::ServerError when any other server-side error occurs
    def get_properties(client_name)
      raise ArgumentError.new("Client name must not be blank") if client_name.nil? || client_name.strip.empty?
      raise ArgumentError.new("Client name must be 16 characters or less") if client_name.length > 16

      begin
        response = soap_client.request :wsdl, :get_properties do
          soap.element_form_default = :qualified
          soap.body = {:request => {:client_name => client_name}}
        end

        properties = [response.to_hash[:get_properties_response][:return][:property]].flatten

        properties.each do |prop|
          convert_types(prop, [:unit_count, :year_built]) { |val| val.to_i }
          convert_types(prop, [:longitude, :latitude]) { |val| val.to_f }
        end

        properties
      rescue Savon::SOAP::Fault => f
        # TODO: Refactor somewhere shared. (probably into YieldStarClient::ServerError)
        # This logic is going to be the same for most of the soap actions.
        fault = f.to_hash[:fault]
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
    end

    private
    # TODO: refactor this somewhere it can be shared. Or find an open-source project where someone else
    # did it better.
    def convert_types(hash, keys, &block)
      keys.each { |k| hash[k] = yield hash[k] if hash.has_key?(k) }
      hash
    end
  end
end
