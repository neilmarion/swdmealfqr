module YieldStarClient
  module GetRenewalLeaseTermRent
    class Response < BaseResponse

      configure_for_lease_term_rent(
        accessor_method: :renewal_lease_term_rents,
        result_class: RenewalLeaseTermRent,
        soap_wrapper_element: :get_renewal_lease_term_rent_response,
        soap_unit_element: :renewal_lease_term_rent_unit_response,
      )

    end
  end
end
