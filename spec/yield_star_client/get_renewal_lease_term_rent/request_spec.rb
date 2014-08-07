require "spec_helper"

module YieldStarClient
  module GetRenewalLeaseTermRent
    describe Request do

      it "is configured to get renewal lease term rents" do
        opts = described_class.lease_term_request_opts
        expect(opts[:request_element]).
          to eq :renewal_lease_term_rent_unit_request
      end

      it "has the correct SOAP_ACTION" do
        expect(described_class::SOAP_ACTION).to eq :get_renewal_lease_term_rent
      end

    end
  end
end
