require 'savon'

require 'yield_star_client/property_methods'
require 'yield_star_client/floor_plan_methods'
require 'yield_star_client/unit_methods'
require 'yield_star_client/amenity_methods'
require 'yield_star_client/rent_methods'
require 'yield_star_client/lease_term_rent_methods'

require 'yield_star_client/errors'

module YieldStarClient
  # YieldStarClient::Client is the main object for connecting to the YieldStar AppExchange service.
  # The interface strives to be SOAP-agnostic whenever possible; all inputs and outputs are pure ruby 
  # and no knowledge of SOAP is required in order to use the client.
  class Client
    include PropertyMethods
    include FloorPlanMethods
    include UnitMethods
    include AmenityMethods
    include RentMethods
    include LeaseTermRentMethods

    attr_writer *YieldStarClient::VALID_CONFIG_OPTIONS

    YieldStarClient::VALID_CONFIG_OPTIONS.each do |opt|
      define_method(opt) { get_value(opt) }
    end

    def debug=(val)
      @debug = val
      Savon.log = self.debug?
    end

    def debug?
      get_value(:debug).to_s == 'true'
    end

    def logger=(val)
      @logger = val
      Savon.logger = self.logger
    end

    # Initializes the client. All options are truly optional; if the option
    # is not supplied to this method, then it will be set based on the
    # YieldStarClient configuration.
    #
    # @see YieldStarClient.configure
    #
    # @param [Hash] options
    # @option options [String] :username The username for authenticating to the web service.
    # @option options [String] :password The password for authenticating to the web service.
    # @option options [String] :client_name The YieldStar client name (required for all requests)
    # @option options [String] :endpoint The address for connecting to the web service.
    # @option options [String] :namespace The XML namespace to use for requests.
    # @option options [true,false] :debug true to enable debug logging of SOAP traffic; defaults to false
    def initialize(options={})
      self.debug = nil
      self.logger = nil
      options.each { |k,v| self.send("#{k}=", v) if self.respond_to?("#{k}=") }
    end

    private
    # Sends a request directly to the SOAP service.
    #
    # @param [Symbol] soap_action the action to be invoked
    # @param [Hash] soap_parameters the parameters to populate the request body
    # @return [Savon::SOAP::Response]
    def send_soap_request(soap_action,soap_parameters={})
      validate_client_name!(client_name)
      default_params = { :client_name => client_name }
      begin
        response = soap_client.request :wsdl, soap_action do
          soap.element_form_default = :qualified
          soap.body = { :request => default_params.merge(soap_parameters) }
        end
      rescue Savon::SOAP::Fault => f
        raise ServerError.translate_fault(f)
      end
    end

    # Sets up a SOAP client for sending SOAP requests directly.
    #
    # @return [Savon::Client]
    def soap_client
      Savon::Client.new do
        wsdl.endpoint = self.endpoint.to_s
        wsdl.namespace = self.namespace
        http.auth.basic self.username, self.password
      end
    end

    # Retrieves an attribute's value. If the attribute has not been set
    # on this object, it is retrieved from the global configuration.
    #
    # @see YieldStarClient.configure
    # 
    # @param [Symbol] attribute the name of the attribute
    # @return [String] the value of the attribute
    def get_value(attribute)
      local_val = instance_variable_get("@#{attribute}")
      local_val.nil? ? YieldStarClient.send(attribute) : local_val
    end
  end
end
