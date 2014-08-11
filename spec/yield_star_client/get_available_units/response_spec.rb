require "spec_helper"

module YieldStarClient
  module GetAvailableUnits
    describe Response do

      describe "#available_units" do
        let(:soap_response) { double(to_hash: response_hash) }
        let(:response_hash) { {} }
        let(:available_floor_plan_1_hash) do
          { external_property_id: "external_property_id_1" }
        end
        let(:available_floor_plan_2_hash) do
          { external_property_id: "external_property_id_2" }
        end
        let(:available_floor_plan_1) { double(AvailableFloorPlan) }
        let(:available_floor_plan_2) { double(AvailableFloorPlan) }
        let(:available_floor_plan_hashes) do
          [ available_floor_plan_1_hash, available_floor_plan_2_hash ]
        end

        it "returns AvailableFloorPlan objects from the soap response" do
          allow(ExtractAvailableFloorPlanHashes).to receive(:execute).
            with(response_hash).
            and_return(available_floor_plan_hashes)

          allow(AvailableFloorPlan).to receive(:new).
            with(available_floor_plan_1_hash).
            and_return(available_floor_plan_1)
          allow(AvailableFloorPlan).to receive(:new).
            with(available_floor_plan_2_hash).
            and_return(available_floor_plan_2)

          available_floor_plans = described_class.new(soap_response).
            available_units

          expect(available_floor_plans).
            to eq [available_floor_plan_1, available_floor_plan_2]
        end
      end

    end
  end
end
