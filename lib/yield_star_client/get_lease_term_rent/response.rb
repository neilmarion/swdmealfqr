module YieldStarClient
  module GetLeaseTermRent
    class Response < BaseResponse

      configure_for_lease_term_rent(
        accessor_method: :lease_term_rents,
        result_class: LeaseTermRent,
        soap_wrapper_element: :get_lease_term_rent_response,
        soap_unit_element: :lease_term_rent_unit_response,
      )

    end
  end
end
