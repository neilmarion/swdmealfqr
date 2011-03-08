require 'validations'
require 'modelish'

module YieldStarClient
  # Represents a summary of rent information for a floor plan/unit type combination.
  #
  # @attr [Date] effective_date the data on which all listed prices are considered effective
  # @attr [String] external_property_id the ID of the property associated with the floor plan
  # @attr [String] floor_plan_name the floor plan that matches the Price Optimizer dashboard
  # @attr [String] unit_type the unit type for this information
  # @attr [Float] bedrooms the number of bedrooms in this unit type
  # @attr [Float] bathrooms the number of bathrooms in this unit type
  # @attr [Integer] avg_square_feet the average square footage in this unit type
  # @attr [Integer] min_market_rent the minimum market rents for the currently available units
  #                                 in this unit type
  # @attr [Integer] max_market_rent the maximum market rents for the currently available units
  #                                 in this unit type
  # @attr [Object] concession_type reserved for future use by YieldStar
  # @attr [Integer] min_concession the minimum value of any ocncessions (rent discount,
  #                                recurrent discounts currently being offtered) for
  #                                this particular unit type
  # @attr [Integer] max_concession the maximum value of any concessions (rent discounts,
  #                                recurrent discounts currently being offered) for this
  #                                particular unit type
  # @attr [Integer] min_final_rent the minimum **EFFECTIVE** rents for the currently available
  #                                units in this unit type
  # @attr [Integer] max_final_rent the maximum **EFFECTIVE** rents for the currently available
  #                                units in this unit type.
  # @attr [String] floor_plan_description the marketing name of the floor plan
  class RentSummary < Modelish::Base
    property :effective_date, :type => Date
    property :external_property_id
    property :floor_plan_name
    property :unit_type
    property :bedrooms, :type => Float, :from => :bed_rooms
    property :bathrooms, :type => Float, :from => :bath_rooms
    property :avg_square_feet, :type => Integer, :from => :avg_sq_ft
    property :min_market_rent, :type => Integer
    property :max_market_rent, :type => Integer
    property :concession_type
    property :min_concession, :type => Integer
    property :max_concession, :type => Integer
    property :min_final_rent, :type => Integer
    property :max_final_rent, :type => Integer
    property :floor_plan_description
  end

  module RentMethods
    # Retrieves high-level rent information for all currently available floor
    # plans within a specific property.
    #
    # @param [String] client_name the YieldStar client name
    # @param [String] external_property_id the ID of the property associated
    #                                      with the requested data
    #
    # @return [Array<YieldStarClient::RentSummary>]
    #
    # @raise [ArgumentError] when a required argument is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_rent_summary(client_name, external_property_id)
      validate_client_name(client_name)
      validate_external_property_id(external_property_id)

      response = send_soap_request(:get_rent_summary, :client_name => client_name,
                                                      :external_property_id => external_property_id)

      data = response.to_hash[:get_rent_summary_response][:return]
      shared_props = {:external_property_id => data[:external_property_id],
                      :effective_date => data[:effective_date]}
      summaries = []
      summaries << data[:floor_plan_unit_type] if data[:floor_plan_unit_type]

      summaries.flatten.collect { |s| RentSummary.new(shared_props.merge(s)) }
    end
  end
end
