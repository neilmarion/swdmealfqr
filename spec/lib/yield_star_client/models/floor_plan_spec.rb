require "spec_helper"

module YieldStarClient
  describe FloorPlan do
    describe ".new_from_rent_summary_hash" do
      let(:hash) do
        {
          unit_type: "1BRa",
          min_market_rent: 10,
          max_market_rent: 30,
          min_final_rent: 15,
          max_final_rent: 35,
          avg_sq_ft: 800,
          bed_rooms: 2,
          bath_rooms: 1.5
        }
      end

      it "maps hash attributes to the correct FloorPlan attribute" do
        floor_plan = FloorPlan.new_from_rent_summary_hash(hash)

        expect(floor_plan.id).to eq "1BRa"
        expect(floor_plan.name).to eq "1BRa"
        expect(floor_plan.min_market_rent).to eq 10.0
        expect(floor_plan.max_market_rent).to eq 30.0
        expect(floor_plan.min_final_rent).to eq 15.0
        expect(floor_plan.max_final_rent).to eq 35.0
        expect(floor_plan.square_feet).to eq 800
        expect(floor_plan.bedrooms).to eq 2.0
        expect(floor_plan.bathrooms).to eq 1.5
      end
    end
  end
end
