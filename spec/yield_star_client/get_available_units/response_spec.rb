require "spec_helper"

module YieldStarClient
  module GetAvailableUnits
    describe Response do

      describe "#available_floor_plans" do
        let(:soap_response) { double(to_hash: response_hash) }
        let(:response_hash) do
          [
            {
              external_property_id: "external_property_id",
            }
          ]
        end

        before do
          allow_any_instance_of(described_class).
            to receive(:extract_available_floor_plan_hashes_from).
            and_return(response_hash)
        end

        it "returns an array of FloorPlan objects" do
          result = described_class.new(soap_response)

          expect(result.available_floor_plans.first).to be_a FloorPlan
          expect(result.available_floor_plans.map(&:external_property_id)).
            to match_array(
              [
                "external_property_id",
              ]
            )
        end
      end

    end
  end
end
