require 'yield_star_client/validations'
require 'modelish'

module YieldStarClient
  module LeaseTermRentMethods

    def get_lease_term_rent(data)
      request_args = default_savon_params.merge(data)
      response = GetLeaseTermRent::Request.execute(request_args)
      GetLeaseTermRent::Response.new(response).lease_term_rents
    end

  end
end
