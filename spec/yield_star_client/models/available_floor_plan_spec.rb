require 'spec_helper'

module YieldStarClient
  RSpec.describe AvailableFloorPlan do

    describe "#id" do
      let(:floor_plan) do
        build(:yield_star_client_available_floor_plan, {
          floor_plan_name: "floor_plan_name",
        })
      end

      it "is an alias of floor_plan_name" do
        expect(floor_plan.id).to eq "floor_plan_name"
      end
    end

  end
end
