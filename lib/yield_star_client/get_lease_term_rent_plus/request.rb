module YieldStarClient
  module GetLeaseTermRentPlus
    class Request < BaseRequest

      SOAP_ACTION = :get_lease_term_rent_plus

      configure_for_lease_term_rent(
        request_element: :lease_term_rent_unit_request,
      )

    end
  end
end
