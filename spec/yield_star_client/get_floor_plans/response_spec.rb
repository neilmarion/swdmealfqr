require "spec_helper"

module YieldStarClient
  module GetFloorPlans
    describe Response do

      describe "#floor_plans" do
        let(:soap_response) do
          double(
            to_hash: {
              get_floor_plans_response: {
                return: {
                  external_property_id: "external_property_id",
                  floor_plan_name: "floor_plan_name",
                  floor_plan: floor_plan_response,
                }
              }
            }
          )
        end

        subject { described_class.new(soap_response).floor_plans }

        context "there are no floor_plans" do
          let(:floor_plan_response) { nil }
          it { is_expected.to be_empty }
        end

        context "there is one floor_plan" do
          let(:floor_plan) { double(FloorPlan) }
          let(:floor_plan_attributes) do
            { external_property_id: "external_property_id" }
          end
          let(:floor_plan_response) { floor_plan_attributes }
          before do
            allow(FloorPlan).to receive(:new).with(floor_plan_attributes).
              and_return(floor_plan)
          end
          it { is_expected.to eq [floor_plan] }
        end

        context "there are multiple floor_plans" do
          let(:floor_plan_1) { double(FloorPlan) }
          let(:floor_plan_2) { double(FloorPlan) }

          let(:floor_plan_1_attributes) do
            { external_property_id: "external_property_id_1" }
          end

          let(:floor_plan_2_attributes) do
            { external_property_id: "external_property_id_2" }
          end

          let(:floor_plans) { [floor_plan_1, floor_plan_2] }
          let(:floor_plan_response) do
            [floor_plan_1_attributes, floor_plan_2_attributes]
          end

          before do
            allow(FloorPlan).to receive(:new).with(floor_plan_1_attributes).
              and_return(floor_plan_1)
            allow(FloorPlan).to receive(:new).with(floor_plan_2_attributes).
              and_return(floor_plan_2)
          end
          it { is_expected.to eq floor_plans }
        end
      end

    end
  end
end
