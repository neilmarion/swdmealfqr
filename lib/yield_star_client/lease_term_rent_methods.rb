require 'yield_star_client/validations'
require 'modelish'

module YieldStarClient
  module LeaseTermRentMethods

    def get_lease_term_rent_with_unit_number_only(external_property_id, unit_number, opts={})
      request_args = default_savon_params.merge(
        external_property_id: external_property_id,
        unit_number: unit_number
      ).merge(opts)

      response = GetLeaseTermRent::Request.execute(request_args)
      GetLeaseTermRent::Response.new(response).lease_term_rents
    end

    def get_lease_term_rent(*args)
      unless args.first.kind_of?(Hash)
        return get_lease_term_rent_with_unit_number_only(*args)
      end

      request_args = default_savon_params.merge(args.first)
      response = GetLeaseTermRent::Request.execute(request_args)
      GetLeaseTermRent::Response.new(response).lease_term_rents
    end

    def get_lease_term_rent_plus(external_property_id, unit_number, opts={})
      request_args = default_savon_params.merge(
        external_property_id: external_property_id,
        unit_number: unit_number
      ).merge(opts)

      response = GetLeaseTermRentPlus::Request.execute(request_args)
      GetLeaseTermRentPlus::Response.new(response).lease_term_rents
    end

    def get_renewal_lease_term_rent(external_property_id, unit_number, opts={})
      request_args = default_savon_params.merge(
        external_property_id: external_property_id,
        unit_number: unit_number
      ).merge(opts)

      response = GetRenewalLeaseTermRent::Request.execute(request_args)
      GetRenewalLeaseTermRent::Response.new(response).renewal_lease_term_rents
    end

  end
end
