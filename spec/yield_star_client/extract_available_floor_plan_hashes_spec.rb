require "spec_helper"

module YieldStarClient
  describe ExtractAvailableFloorPlanHashes, ".execute" do

    let(:effective_date) { Date.new(2018, 2, 1) }
    let(:response_hash) do
      {
        get_available_units_response: {
          return: {
            external_property_id: "external_property_id",
            effective_date: effective_date,
            floor_plan: floor_plan,
          }
        }
      }
    end

    subject { described_class.execute(response_hash) }

    context "there is no floor_plan" do
      let(:floor_plan) { nil }
      it { is_expected.to eq [] }
    end

    context "there is one floor_plan" do
      let(:floor_plan) { { floor_plan_name: "type 1" } }
      let(:expected_array) do
        [
          floor_plan.merge(
            external_property_id: "external_property_id",
            effective_date: effective_date,
          )
        ]
      end
      it { is_expected.to eq expected_array }
    end

    context "there are multiple values in floor_plan" do
      let(:floor_plan) do
        [
          { floor_plan_name: "type 1" },
          { floor_plan_name: "type 2" },
        ]
      end
      let(:expected_array) do
        [
          {
            external_property_id: "external_property_id",
            effective_date: effective_date,
            floor_plan_name: "type 1",
          },
          {
            external_property_id: "external_property_id",
            effective_date: effective_date,
            floor_plan_name: "type 2",
          }
        ]
      end
      it { is_expected.to eq expected_array }
    end

  end
end
