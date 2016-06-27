require 'spec_helper'

module YieldStarClient
  describe Client do

    let(:client) do
      described_class.new(CONFIG.merge(
        debug: true,
        logger: Logger.new("tmp/test.log"),
      ))
    end

    describe "#get_floor_plans" do
      it "returns floor plans", vcr: {record: :once} do
        floor_plans = catch(:floor_plans) do
          client.get_properties.each do |property|
            external_property_id = property.external_property_id
            floor_plans = client.get_floor_plans(external_property_id)
            throw :floor_plans, floor_plans if floor_plans.any?
          end
          throw :floor_plans, nil
        end

        fail "Could not find floor plans to test" if floor_plans.empty?
        expect(floor_plans.first).to be_a FloorPlan
      end
    end

    describe "#get_floor_plan" do
      it "returns floor plans", vcr: {record: :once} do
        property = client.get_properties.first
        external_property_id = property.external_property_id
        floor_plans = client.get_floor_plans(external_property_id)
        floor_plan = client.get_floor_plan(
          external_property_id,
          floor_plans.first.name
        )
        expect(floor_plan).to be_a FloorPlan
        expect(floor_plan.external_property_id).to eq external_property_id
      end
    end

    describe "#get_floor_plans_with_units" do
      it "returns all floorplans with their units", vcr: { record: :once } do
        property = client.get_properties.first
        external_property_id = property.external_property_id
        floor_plans_with_units = client.get_floor_plans_with_units(external_property_id)

        floor_plan = floor_plans_with_units.first

        expect(floor_plan).to be_a FloorPlan
        expect(floor_plan.units.first).to be_an AvailableUnit
      end
    end

  end

end
