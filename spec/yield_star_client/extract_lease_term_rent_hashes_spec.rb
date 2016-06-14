require "spec_helper"

module YieldStarClient
  describe ExtractLeaseTermRentHashes, ".from" do

    let(:make_ready_date) { Date.new(2014, 1, 1) }
    let(:soap_response) { double(to_hash: response_hash) }
    let(:response_hash) do
      {
        soap_wrapper_element => {
          return: {
            external_property_id: "external_property_id",
            soap_unit_element => ltr_plus_response_hashes
          }
        }
      }
    end
    let(:ltr_plus_response_hashes) { response_value_for_single_unit }
    let(:response_value_for_single_unit) do
      {
        unit_number: "unit_number",
        building: "building",
        make_ready_date: make_ready_date,
        unit_rate: unit_rate,
      }
    end

    let(:soap_wrapper_element) { :get_lease_term_rent_plus_response }
    let(:soap_unit_element) { :lease_term_rent_unit_plus_response }

    subject do
      described_class.from(
        soap_response,
        soap_wrapper_element: soap_wrapper_element,
        soap_unit_element: soap_unit_element,
      )
    end

    context "there are multiple unit rates" do
      let(:unit_rate) do
        [
          {rate_info: "1"},
          {rate_info: "2"},
        ]
      end

      it do
        lease_term_hash_1 = {
          external_property_id: "external_property_id",
          unit_number: "unit_number",
          building: "building",
          make_ready_date: make_ready_date,
          rate_info: "1",
        }

        lease_term_hash_2 = {
          external_property_id: "external_property_id",
          unit_number: "unit_number",
          building: "building",
          make_ready_date: make_ready_date,
          rate_info: "2",
        }

        expected_hashes = [lease_term_hash_1, lease_term_hash_2]
        is_expected.to eq expected_hashes
      end
    end

    context "there is a single property" do
      let(:unit_rate) {{rate_info: "1"}}

      it do
        lease_term_hash = {
          external_property_id: "external_property_id",
          unit_number: "unit_number",
          building: "building",
          make_ready_date: make_ready_date,
          rate_info: "1",
        }

        is_expected.to eq [lease_term_hash]
      end
    end

    context "there is no property" do
      let(:unit_rate) { nil }
      it { is_expected.to be_empty }
    end

    context "there are multiple unit rates for multiple units" do
      let(:ltr_plus_response_hashes) { response_value_for_multiple_units }
      let(:response_value_for_multiple_units) do
        [
          {
            unit_number: "unit_number",
            building: "building",
            make_ready_date: make_ready_date,
            unit_rate: [{rate_info: "1"}, {rate_info: "2"}],
          },
          {
            unit_number: "unit_number_2",
            building: "building",
            make_ready_date: make_ready_date,
            unit_rate: {rate_info: "3"},
          }
        ]
      end

      it "expected to return lease term rent hashes into one flat array" do
        expect(subject).to eq [
          {
            external_property_id: "external_property_id",
            unit_number: "unit_number",
            building: "building",
            make_ready_date: make_ready_date,
            rate_info: "1",
          },
          {
            external_property_id: "external_property_id",
            unit_number: "unit_number",
            building: "building",
            make_ready_date: make_ready_date,
            rate_info: "2",
          },
          {
            external_property_id: "external_property_id",
            unit_number: "unit_number_2",
            building: "building",
            make_ready_date: make_ready_date,
            rate_info: "3",
          },
        ]
      end
    end
  end
end
