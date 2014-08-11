require "spec_helper"

module YieldStarClient
  module GetFloorPlan
    describe Response do

      describe "#floor_plan" do
        let(:soap_response) do
          double(
            to_hash: {
              get_floor_plan_response: {
                return: {
                  floor_plan: floor_plan_response,
                }
              }
            }
          )
        end

        subject { described_class.new(soap_response).floor_plan }

        let(:floor_plan) { double(FloorPlan) }
        let(:floor_plan_attributes) do
          { external_property_id: "external_property_id" }
        end
        let(:floor_plan_response) { floor_plan_attributes }
        before do
          allow(FloorPlan).to receive(:new).with(floor_plan_attributes).
            and_return(floor_plan)
        end
        it { is_expected.to eq floor_plan }
      end

    end
  end
end
