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
  end

  # Represents an error in authenticating to the web service
  class AuthenticationError < ServerError; end

  # Represents an internal error in the web service
  class InternalError < ServerError; end

  # Represents an operation error in the web service
  class OperationError < ServerError; end
end
