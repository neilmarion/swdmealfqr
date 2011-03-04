module YieldStarClient
  # Represents a server-side error returned by the YieldStar web service.
  class ServerError < StandardError
    attr_reader :code

    # Creates a new error object.
    #
    # @param [String] message the error message. If no message is supplied, the
    #                 object's class name will be used as the message.
    # @param [String] code the error code    
    def initialize(message=nil, code=nil)
      super(message)
      @code = code
    end

    # Translates a soap fault into the appropriate YieldStarClient error.
    #
    # @param [Savon::SOAP::Fault] soap_error the error object raised by the soap client
    # @return [YieldStarClient::ServerError] the corresponding YieldStarClient error
    def self.translate_fault(soap_error)
      fault = soap_error.to_hash[:fault]

      # set up defaults
      error_class = YieldStarClient::ServerError
      fault_detail = {:code => fault[:faultcode], :message => fault[:faultstring]}

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

      error_class.new(fault_detail[:message], fault_detail[:code])
    end
  end

  # Represents an error in authenticating to the web service
  class AuthenticationError < ServerError; end

  # Represents an internal error in the web service
  class InternalError < ServerError; end

  # Represents an operation error in the web service
  class OperationError < ServerError; end
end
