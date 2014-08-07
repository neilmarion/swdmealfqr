require "spec_helper"

module YieldStarClient
  module GetLeaseTermRent
    describe Request do

      it "is configured to get lease term rents" do
        expect(described_class.lease_term_request_opts[:request_element]).
          to eq :lease_term_rent_unit_request
      end

      it "has the correct SOAP_ACTION" do
        expect(described_class::SOAP_ACTION).to eq :get_lease_term_rent
      end

    end
  end
end
