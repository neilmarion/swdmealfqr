require "spec_helper"

module YieldStarClient
  describe ExtractRentSummaryHashes, ".execute" do

    let(:effective_date) { Date.new(2018, 2, 1) }
    let(:response_hash) do
      {
        get_rent_summary_response: {
          return: {
            external_property_id: "external_property_id",
            effective_date: effective_date,
            floor_plan_unit_type: floor_plan_unit_type,
          }
        }
      }
    end

    subject { described_class.execute(response_hash) }

    context "there is no floor_plan_unit_type" do
      let(:floor_plan_unit_type) { nil }
      it { is_expected.to eq [] }
    end

    context "there is one floor_plan_unit_type" do
      let(:floor_plan_unit_type) { { unit_type: "type 1" } }
      let(:expected_array) do
        [
          floor_plan_unit_type.merge(
            external_property_id: "external_property_id",
            effective_date: effective_date,
          )
        ]
      end
      it { is_expected.to eq expected_array }
    end

    context "there are multiple values in floor_plan_unit_type" do
      let(:floor_plan_unit_type) do
        [
          { unit_type: "type 1" },
          { unit_type: "type 2" },
        ]
      end
      let(:expected_array) do
        [
          {
            external_property_id: "external_property_id",
            effective_date: effective_date,
            unit_type: "type 1",
          },
          {
            external_property_id: "external_property_id",
            effective_date: effective_date,
            unit_type: "type 2",
          }
        ]
      end
      it { is_expected.to eq expected_array }
    end

  end
end
