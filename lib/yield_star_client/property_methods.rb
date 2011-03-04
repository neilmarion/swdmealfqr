require 'validations'
require 'errors'

module YieldStarClient
  module PropertyMethods
    include Validations

    # Retrieves all properties for a client.
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
      validate_client_name(client_name)

      begin
        response = soap_client.request :wsdl, :get_properties do
          soap.element_form_default = :qualified
          soap.body = {:request => {:client_name => client_name}}
        end

        properties = [response.to_hash[:get_properties_response][:return][:property]].flatten
        properties.collect{ |prop| process_property(prop) }
      rescue Savon::SOAP::Fault => f
        raise ServerError.translate_fault(f)
      end 
    end

    # Retrieves information for a specific property.
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
    # @return [Hash] the property data
    # @raise [ArgumentError] when external_property_id or client_name are missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_property(client_name, external_property_id)
      validate_client_name(client_name)
      validate_external_property_id(external_property_id)

      begin
        response = soap_client.request :wsdl, :get_property do
          soap.element_form_default = :qualified
          soap.body = {:client_name => client_name, :external_property_id => external_property_id}
        end

        property = response.to_hash[:get_property_response][:return][:property]
        process_property(property)
      rescue Savon::SOAP::Fault => f
        raise ServerError.translate_fault(f)
      end
    end


    # Retrieves pricing parameters for a specific property.
    #
    # Possible pricing parameters are:
    #
    # <b>+:post_date+</b>:: the post date of the latest Price Optimizer forecasting and optimization nightly run. +(Date)+
    # <b>+:min_new_lease_term+</b>:: minimum length (in months) of a new lease term +(Integer)+
    # <b>+:max_new_lease_term+</b>:: maximum length (in months) of a new lease term +(Integer)+
    # <b>+:new_lease_term_options+</b>:: absolute number of lease term options to offer on either side of the base lease term when creating the lease term rent matrix. +(Integer)+
    # <b>+:max_move_in_days+</b>:: number of fixed move in date options to return in response to a request for lease rates. +(Integer)+
    # <b>+:min_renewal_lease_term+</b>:: minimum length (in months) of a renewal lease term +(Integer)+
    # <b>+:max_renewal_lease_term+</b>:: maximum length (in months) of a renewal lease term +(Integer)+
    #
    # @param [String] client_name the name of the client to perform the request for
    # @param [String] external_property_id the ID of the property to obtain information for
    # @return [Hash] the pricing data
    # @raise [ArgumentError] when external_property_id or client_name are missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_property_parameters(client_name, external_property_id)
      validate_client_name(client_name)
      validate_external_property_id(external_property_id)

      begin
        response = soap_client.request :wsdl, :get_property_parameters do
          soap.element_form_default = :qualified
          soap.body = {:client_name => client_name, :external_property_id => external_property_id}
        end

        param_hash = {}
        params = response.to_hash[:get_property_parameters_response][:return][:parameter]

        unless params.nil?
          [params].flatten.each do |param|
            name = param[:name].downcase.gsub(/(max|min)imum/, '\1').gsub(/\s+/, '_').to_sym

            if name == :post_date
              value = Date.parse(param[:value])
            elsif param[:value]
              value = param[:value].to_i
            end

            param_hash[name] = value
          end
        end

        param_hash
      rescue Savon::SOAP::Fault => f
        raise ServerError.translate_fault(f)
      end
    end

    private
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
