require 'yield_star_client/validations'
require 'modelish'

module YieldStarClient
  # Represents a property in the YieldStar system.
  #
  # A property is guaranteed to have an +external_property_id+ and +name+; all other attributes are optional.
  #
  # @attr [String] external_property_id the property ID
  # @attr [String] name the name of the property
  # @attr [String] address the street address
  # @attr [String] city the city in which the property is located
  # @attr [String] state the two-letter code of the state in which the property is located
  # @attr [String] zip the zip code
  # @attr [String] fax the fax telephone number
  # @attr [String] phone the voice telephone number
  # @attr [Float] latitude the latitude of the property's location
  # @attr [Float] longitude the longitude of the property's location
  # @attr [Integer] unit_count the number of units at this property
  # @attr [String] website the URL of the property website
  # @attr [Integer] year_built the year in which the property was built
  class Property < Modelish::Base
    property :external_property_id
    property :name
    property :address
    property :city
    property :state
    property :zip
    property :fax
    property :phone
    property :latitude, :type => Float
    property :longitude, :type => Float
    property :unit_count, :type => Integer
    property :website
    property :year_built, :type => Integer
  end

  # Represents the pricing parameters for a particular property.
  #
  # This object is guaranteed to have an +external_property_id+; all other attributes may be nil.
  #
  # @attr [String] external_property_id the ID of the property
  # @attr [Date] post_date the post date of the latest Price Optimizer forecasting and optimization nightly run.
  # @attr [Integer] min_new_lease_term minimum length (in months) of a new lease term
  # @attr [Integer] max_new_lease_term maximum length (in months) of a new lease term
  # @attr [Integer] new_lease_term_options absolute number of lease term options to offer on either side of the base lease term when creating the lease term rent matrix.
  # @attr [Integer] max_move_in_days number of fixed move in date options to return in response to a request for lease rates.
  # @attr [Integer] min_renewal_lease_term minimum length (in months) of a renewal lease term
  # @attr [Integer] max_renewal_lease_term maximum length (in months) of a renewal lease term
  class PropertyParameters < Modelish::Base
    property :external_property_id
    property :post_date, :type => Date
    property :min_new_lease_term, :type => Integer
    property :max_new_lease_term, :type => Integer
    property :new_lease_term_options, :type => Integer
    property :max_move_in_days, :type => Integer
    property :min_renewal_lease_term, :type => Integer
    property :max_renewal_lease_term, :type => Integer
  end

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
      response = send_soap_request(:get_properties)

      props = response.to_hash[:get_properties_response][:return][:property] || []
      props = [props].flatten
      props.collect { |p| Property.new(p) }
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
