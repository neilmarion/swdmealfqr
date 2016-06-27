require 'yield_star_client/validations'
require 'modelish'

module YieldStarClient
  module RentMethods
    # Retrieves high-level rent information for all currently available floor
    # plans within a specific property.
    #
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
    def get_rent_summary(external_property_id)
      request_args = default_savon_params.
        merge(external_property_id: external_property_id)
      response = GetRentSummary::Request.execute(request_args)
      GetRentSummary::Response.new(response).rent_summaries
    end
  end
end
