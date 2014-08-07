require "spec_helper"

module YieldStarClient
  describe LeaseTermResponseConfig do
    class FakeResponse < BaseResponse
      configure_for_lease_term_rent(
        accessor_method: :lease_term_rents,
        result_class: LeaseTermRent,
        soap_wrapper_element: :soap_wrapper_element,
        soap_unit_element: :soap_unit_element,
      )
    end

    let(:accessor_method) { :lease_term_rents }
    let(:result_class) { LeaseTermRent }

    let(:soap_response) { double }

    let(:lease_term_rent_hash_1) {{ hash: 1 }}
    let(:lease_term_rent_hash_2) {{ hash: 2 }}

    let(:lease_term_rent_1) { double(result_class) }
    let(:lease_term_rent_2) { double(result_class) }

    let(:lease_term_rent_hashes) do
      [lease_term_rent_hash_1, lease_term_rent_hash_2]
    end

    before do
      allow(ExtractLeaseTermRentHashes).to receive(:from).with(
        soap_response,
        soap_wrapper_element: :soap_wrapper_element,
        soap_unit_element: :soap_unit_element,
      ).and_return(lease_term_rent_hashes)

      allow(result_class).to receive(:new_from).
        with(lease_term_rent_hash_1).
        and_return(lease_term_rent_1)

      allow(result_class).to receive(:new_from).
        with(lease_term_rent_hash_2).
        and_return(lease_term_rent_2)
    end

    subject(:resulting_lease_term_rents) do
      FakeResponse.new(soap_response).send(accessor_method)
    end

    it "returns lease term rents" do
      expect(resulting_lease_term_rents).to eq([
        lease_term_rent_1,
        lease_term_rent_2,
      ])
    end

  end
end
