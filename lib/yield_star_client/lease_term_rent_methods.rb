require 'yield_star_client/validations'
require 'modelish'

module YieldStarClient
  # Represents unit rate data for a combination of lease term
  # and move-in date for a particular unit.
  #
  # @attr [String] external_property_id the ID of the property where the unit is located
  # @attr [String] building the building in which the unit is located
  # @attr [Date] make_ready_date the actual date the unit is made available
  # @attr [String] unit_number the unit number identifying this unit
  # @attr [Integer] lease_term the length, in months, of the lease term
  # @attr [Date] end_date the date the proposed lease will expire
  # @attr [Integer] market_rent the market rent for the current lease
  # @attr [Integer] final_rent the effective rent for the current lease
  # @attr [true,false] best indicates whether this is the best (i.e. highest) rent 
  #                         for the unit; defaults to true
  # @attr [Date] move_in_date the move-in date used in project optimum rents for the unit
  # @attr [Integer] total_concession the total concession amount (defaults to 0)
  # @attr [Integer] monthly_fixed_concession the monthly fixed concession amount (defaults to 0)
  # @attr [Float] monthly_percent_concession the monthly concession percentage (defaults to 0.0)
  # @attr [Float] months_concession the months concession (defaults to 0.0)
  # @attr [Integer] one_time_fixed_concession the one time fixed concession (defaults to 0.0)
  # @attr [Date] price_valid_end_date the last date for which the price is valid
  class UnitRate < Modelish::Base
    property :external_property_id
    property :building
    property :make_ready_date, :type => Date
    property :unit_number
    property :lease_term, :type => Integer
    property :end_date, :type => Date
    property :market_rent, :type => Integer
    property :final_rent, :type => Integer
    property :best, :type => lambda { |val| val.to_s.strip == 'true' }, :default => true
    property :move_in_date, :type => Date
    property :total_concession, :type => Integer, :default => 0
    property :monthly_fixed_concession, :type => Integer, :default => 0
    property :monthly_percent_concession, :type => Float, :default => 0.0
    property :months_concession, :type => Float, :default => 0.0
    property :one_time_fixed_concession, :type => Integer, :default => 0
    property :price_valid_end_date, :type => Date, :from => :pv_end_date
  end

  # @private
  class LeaseTermRentOptions < Modelish::Base
    property :building
    property :min_lease_term, :type => Integer, :validate_type => true
    property :max_lease_term, :type => Integer, :validate_type => true
    property :first_move_in_date, :type => Date, :validate_type => true
    property :last_move_in_date, :type => Date, :validate_type => true
    property :ready_for_move_in_date, :type => Date, :validate_type => true
    property :unit_available_date, :type => Date, :validate_type => true

    def to_request_hash
      h = {}
      self.class.properties.each do |name|
        h[name] = self.send(name).to_s
      end
      h
    end
  end

  module LeaseTermRentMethods
    include Validations

    # Retrieves a matrix providing the specific rate for each combination of 
    # lease term and move-in date for a particular unit.
    #
    # @param [String] client_name the YieldStar client name
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
    # @return [Array<YieldStarClient::UnitRate>] unit rate data
    #
    # @raise [ArgumentError] when a required argument is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_lease_term_rent(client_name, external_property_id, unit_number, opts={})
      call_lease_term_rent_method(client_name, external_property_id, unit_number, opts)
    end

    # This method is identical to {#get_lease_term_rent}, but the return value also includes
    # the last date for which the price is valid.
    #
    # {see #get_lease_term_rent}
    def get_lease_term_rent_plus(client_name, external_property_id, unit_number, opts={})
      call_lease_term_rent_method(client_name, external_property_id, unit_number, opts, '_plus')
    end

    private
    def call_lease_term_rent_method(client_name, external_property_id, unit_number, opts, method_suffix='')
      validate_client_name!(client_name)
      validate_external_property_id!(external_property_id)
      validate_required!(:unit_number => unit_number)

      request_params = {:client_name => client_name, 
                        :external_property_id => external_property_id,
                        :unit_number => unit_number}

      unless opts.nil? || opts.empty?
        lease_term_opts = LeaseTermRentOptions.new(opts)
        lease_term_opts.validate!
        request_params[:lease_term_rent_unit_request] = lease_term_opts.to_request_hash
      end

      soap_action = "get_lease_term_rent#{method_suffix}".to_sym
      response = send_soap_request(soap_action, request_params)
      response_hash = response.to_hash["get_lease_term_rent#{method_suffix}_response".to_sym][:return]["lease_term_rent_unit#{method_suffix}_response".to_sym]

      common_params = {:external_property_id => external_property_id.to_s}
      common_params.merge!(response_hash.reject { |k,v| k == :unit_rate })

      unit_rates = response_hash[:unit_rate] || []
      unit_rates = [unit_rates].flatten

      unit_rates.collect do |r|
        UnitRate.new(common_params.merge(r)) 
      end

    end
  end
end
