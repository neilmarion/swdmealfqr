module YieldStarClient
  module GetRenewalLeaseTermRent
    class Request < BaseRequest

      SOAP_ACTION = :get_renewal_lease_term_rent

      configure_for_lease_term_rent(
        request_element: :renewal_lease_term_rent_unit_request,
      )

    end
  end
end
