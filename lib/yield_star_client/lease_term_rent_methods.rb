require 'yield_star_client/validations'
require 'modelish'

module YieldStarClient
  module LeaseTermRentMethods
    include Validations

    # Retrieves a matrix providing the specific rate for each combination of 
    # lease term and move-in date for a particular unit.
    #
    # @param [String] external_property_id the ID of the property where the unit is located
    # @param [String] unit_number the unit_number that identifies the available unit
    # @param [Hash] opts optional filters for lease term data
    # @option opts [String] :building the building in which the unit is located
    # @option opts [Integer] :min_lease_term the minimum lease term for the lease matrix projections
    # @option opts [Integer] :max_lease_term the maximum lease term for the lease matrix projections
    # @option opts [Date] :first_move_in_date the start of the move-in date range for projecting optimum rents
    # @option opts [Date] :last_move_in_date the end of the move-in date range for projecting optimum rents
    # @option opts [Date] :ready_for_move_in_date the date that the unit is made ready for occupancy
    # @option opts [Date] :unit_available_date the first date that the unit is vacant
    #
    # @return [Array<YieldStarClient::LeaseTermRent>] unit rate data
    #
    # @raise [ArgumentError] when a required argument is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_lease_term_rent(external_property_id, unit_number, opts={})
      opts ||= {}
      call_lease_term_rent_method(external_property_id,
                                  unit_number,
                                  opts.merge(:request_element => :lease_term_rent_unit_request,
                                             :soap_action => :get_lease_term_rent,
                                             :response_element => :lease_term_rent_unit_response,
                                             :result_class => LeaseTermRent))
    end

    # This method is identical to {#get_lease_term_rent}, but the return value also includes
    # the last date for which the price is valid.
    #
    # {see #get_lease_term_rent}
    def get_lease_term_rent_plus(external_property_id, unit_number, opts={})
      opts ||= {}
      call_lease_term_rent_method(external_property_id,
                                  unit_number,
                                  opts.merge(:request_element => :lease_term_rent_unit_request,
                                             :soap_action => :get_lease_term_rent_plus,
                                             :response_element => :lease_term_rent_unit_plus_response,
                                             :result_class => LeaseTermRent))
    end

    # Retrieves rate data for units that are within "Renewal Notice Days" of lease expiration, 
    # and those units for which renewal rates have been manually generated and accepted.
    #
    # @param [String] external_property_id the ID of the property where the unit is located
    # @param [String] unit_number the unit_number that identifies the available unit
    # @param [Hash] opts optional filters for lease term data
    # @option opts [String] :building the building in which the unit is located
    # @option opts [Integer] :min_lease_term the minimum lease term for the lease matrix projections
    # @option opts [Integer] :max_lease_term the maximum lease term for the lease matrix projections
    # @option opts [Date] :start_date the actual start date of the renewal
    #
    # @return [Array<YieldStarClient::RenewalLeaseTermRent>] the list of units up for renewal
    #
    # @raise {see #get_lease_term_rent}
    def get_renewal_lease_term_rent(external_property_id, unit_number, opts={})
      opts ||= {}
      call_lease_term_rent_method(external_property_id,
                                  unit_number,
                                  opts.merge(:request_element => :renewal_lease_term_rent_unit_request,
                                             :soap_action => :get_renewal_lease_term_rent,
                                             :response_element => :renewal_lease_term_rent_unit_response,
                                             :result_class => RenewalLeaseTermRent))
    end

    private
    def call_lease_term_rent_method(external_property_id, unit_number, opts={})
      validate_external_property_id!(external_property_id)
      validate_required!(:unit_number=>unit_number)

      request_opts = opts.merge(:unit_number => unit_number)
      request_opts.delete_if { |k,v| [:request_element, :soap_action, :response_element, :result_class].include?(k) }

      lease_term_opts = LeaseTermRentOptions.new(request_opts.merge(:unit_number => unit_number))
      lease_term_opts.validate!
      request_params = {:client_name => client_name,
                        :external_property_id => external_property_id,
                        opts[:request_element] => lease_term_opts.to_request_hash}

      response = send_soap_request(opts[:soap_action], request_params)
      response_hash = response.to_hash["#{opts[:soap_action]}_response".to_sym][:return][opts[:response_element]] || {}

      common_params = {:external_property_id => external_property_id.to_s}
      common_params.merge!(response_hash.reject { |k,v| k == :unit_rate })

      unit_rates = response_hash[:unit_rate] || []
      unit_rates = [unit_rates].flatten

      unit_rates.collect do |r|
        opts[:result_class].new(common_params.merge(r)) 
      end
    end
  end
end
