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
                  floor_plan: floor_plan_attributes,
                }
              }
            }
          )
        end

        let(:floor_plan_attributes) do
          {
            external_property_id: "property_id",
            name: "name",
            square_footage: 1,
            bed_rooms: 1.5,
            bath_rooms: 1.5
          }
        end

        it "returns a floor plan object" do
          result = described_class.new(soap_response)

          expect(result.floor_plan).to be_a FloorPlan

          expect(result.floor_plan.external_property_id).to eq floor_plan_attributes[:external_property_id]
          expect(result.floor_plan.name).to eq floor_plan_attributes[:name]
          expect(result.floor_plan.square_feet).to eq floor_plan_attributes[:square_footage]
          expect(result.floor_plan.bedrooms).to eq floor_plan_attributes[:bed_rooms]
          expect(result.floor_plan.bathrooms).to eq floor_plan_attributes[:bath_rooms]
        end

      end

    end
  end
end
