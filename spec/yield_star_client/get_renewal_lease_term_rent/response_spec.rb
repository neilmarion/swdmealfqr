require "spec_helper"

module YieldStarClient
  module GetRenewalLeaseTermRent
    describe Response do

      it "is configured to parse renewal lease term rents" do
        opts = described_class.lease_term_response_opts

        accessor_method = opts[:accessor_method]
        result_class = opts[:result_class]
        soap_wrapper_element = opts[:soap_wrapper_element]
        soap_unit_element = opts[:soap_unit_element]

        expect(accessor_method).to eq :renewal_lease_term_rents
        expect(result_class).to eq RenewalLeaseTermRent
        expect(soap_wrapper_element).to eq :get_renewal_lease_term_rent_response
        expect(soap_unit_element).to eq :renewal_lease_term_rent_unit_response
      end

    end
  end
end
