require 'yield_star_client/validations'
require 'modelish'

module YieldStarClient
  # Represents common unit rate information.
  #
  # @attr [String] external_property_id the ID of the property where the unit is located
  # @attr [String] building the building in which the unit is located
  # @attr [String] unit_number the unit number identifying this unit
  # @attr [Integer] lease_term the length, in months, of the lease term
  # @attr [Date] end_date the date the proposed lease will expire
  # @attr [Integer] market_rent the market rent for the current lease
  # @attr [Integer] final_rent the effective rent for the current lease
  # @attr [true,false] best indicates whether this is the best (i.e. highest) rent 
  #                         for the unit; defaults to true
  class UnitRate < Modelish::Base
    property :external_property_id
    property :building
    property :unit_number
    property :lease_term, :type => Integer
    property :end_date, :type => Date
    property :market_rent, :type => Integer
    property :final_rent, :type => Integer
    property :best, :type => lambda { |val| val.to_s.strip == 'true' }, :default => true
  end

  # Represents unit rate data for a combination of lease term
  # and move-in date for a particular unit.
  #
  # @attr {see YieldStarClient::UnitRate}
  # @attr [Date] make_ready_date the actual date the unit is made available
  # @attr [Date] move_in_date the move-in date used in project optimum rents for the unit
  # @attr [Integer] total_concession the total concession amount (defaults to 0)
  # @attr [Integer] monthly_fixed_concession the monthly fixed concession amount (defaults to 0)
  # @attr [Float] monthly_percent_concession the monthly concession percentage (defaults to 0.0)
  # @attr [Float] months_concession the months concession (defaults to 0.0)
  # @attr [Integer] one_time_fixed_concession the one time fixed concession (defaults to 0.0)
  # @attr [Date] price_valid_end_date the last date for which the price is valid
  class LeaseTermRent < UnitRate
    property :make_ready_date, :type => Date
    property :move_in_date, :type => Date
    property :total_concession, :type => Integer, :default => 0
    property :monthly_fixed_concession, :type => Integer, :default => 0
    property :monthly_percent_concession, :type => Float, :default => 0.0
    property :months_concession, :type => Float, :default => 0.0
    property :one_time_fixed_concession, :type => Integer, :default => 0
    property :price_valid_end_date, :type => Date, :from => :pv_end_date
  end

  # Represents rate data for a unit that is up for lease renewal.
  #
  # @attr {see YieldStarClient::UnitRate}
  # @attr [Date] start_date the actual start date of the projected lease (this will only be
  #                         present when a start date was passed in as input
  class RenewalLeaseTermRent < UnitRate
    property :start_date, :type => Date 
  end

  # @private
  class LeaseTermRentOptions < Modelish::Base
    property :unit_number, :required => true, :max_length => 50
    property :building, :max_length => 50
    property :min_lease_term, :type => Integer, :validate_type => true
    property :max_lease_term, :type => Integer, :validate_type => true
    property :first_move_in_date, :type => Date, :validate_type => true
    property :last_move_in_date, :type => Date, :validate_type => true
    property :ready_for_move_in_date, :type => Date, :validate_type => true
    property :unit_available_date, :type => Date, :validate_type => true
    property :start_date, :type => Date, :validate_type => true

    def to_request_hash
      h = {}
      self.class.properties.each do |name|
        h[name] = self.send(name).to_s if self.send(name)
      end
      h
    end
  end

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
