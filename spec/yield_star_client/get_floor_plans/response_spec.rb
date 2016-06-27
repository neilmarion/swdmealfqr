require "spec_helper"

module YieldStarClient
  module GetFloorPlans
    describe Response do
      describe "#floor_plans" do
        it "initializes an array of FloorPlan objects" do
          allow_any_instance_of(described_class).to receive(:floor_plan_hashes).
            and_return(
              [
                {
                  external_property_id: "external_property_id",
                  name: "name",
                  square_footage: "20",
                  bed_rooms: "1.5",
                  bath_rooms: "2.5",
                }
              ]
            )

          result = described_class.new(any_args)
          floor_plan = result.floor_plans.first

          expect(floor_plan.external_property_id).to eq "external_property_id"
          expect(floor_plan.name).to eq "name"
          expect(floor_plan.square_feet).to eq 20
          expect(floor_plan.bedrooms).to eq 1.5
          expect(floor_plan.bathrooms).to eq 2.5
        end

        context "there are no floor_plans" do
          let(:soap_response) do
            double(
              to_hash: {
                get_floor_plans_response: {
                  return: {
                    external_property_id: "external_property_id",
                    floor_plan_name: "floor_plan_name",
                    floor_plan: nil,
                  }
                }
              }
            )
          end

          it "returns an empty array" do
            result = described_class.new(soap_response)

            expect(result.floor_plans).to be_empty
          end
        end

        context "there is one floor_plan" do
          let(:soap_response) do
            double(
              to_hash: {
                get_floor_plans_response: {
                  return: {
                    external_property_id: "external_property_id",
                    floor_plan_name: "floor_plan_name",
                    floor_plan: floor_plan_attributes,
                  }
                }
              }
            )
          end
          let(:floor_plan_attributes) do
            {
              external_property_id: "external_property_id",
            }
          end

          it "returns an array of FloorPlan objects" do
            result = described_class.new(soap_response)
            floor_plans = result.floor_plans

            expect(floor_plans.first).to be_a FloorPlan
          end
        end

        context "there are multiple floor_plans" do
          let(:soap_response) do
            double(
              to_hash: {
                get_floor_plans_response: {
                  return: {
                    external_property_id: "external_property_id",
                    floor_plan_name: "floor_plan_name",
                    floor_plan: [
                      floor_plan_attributes_1,
                      floor_plan_attributes_2,
                    ],
                  }
                }
              }
            )
          end
          let(:floor_plan_attributes_1) do
            {
              external_property_id: "external_property_id",
            }
          end
          let(:floor_plan_attributes_2) do
            {
              external_property_id: "external_property_id",
            }
          end

          it "returns an array of FloorPlan objects" do
            result = described_class.new(soap_response)
            floor_plans = result.floor_plans

            floor_plans.each do |floor_plan|
              expect(floor_plan).to be_a FloorPlan
            end
          end
        end
      end

    end
  end
end
