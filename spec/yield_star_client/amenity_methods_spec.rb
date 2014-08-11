require 'spec_helper'

module YieldStarClient
  describe Client do

    include Savon::SpecHelper

    let(:logger) { Logger.new("tmp/test.log") }
    let(:client_config) do
      CONFIG.merge(
        debug: true,
        logger: logger,
      )
    end

    let(:client) { described_class.new(client_config) }

    describe "#get_floor_plan_amenities" do
      before(:all) { savon.mock! }
      after(:all) { savon.unmock! }

      let(:fixture) do
        path = File.join(
          SPEC_DIR,
          "fixtures",
          "get_floor_plan_amenities",
          "multiple_amenities.xml",
        )
        File.read(path)
      end

      it "returns floor plan amenities", vcr: {record: :once} do
        expected_message = client_config.
          slice(:client_name).
          merge(
            external_property_id: "external_property_id",
            floor_plan_name: "floor_plan_name",
          )

        savon.expects(:get_floor_plan_amenities).
          with(message: {request: expected_message.symbolize_keys}).
          returns(fixture)

        amenities = client.get_floor_plan_amenities(
          "external_property_id",
          "floor_plan_name",
        )

        expect(amenities.first).to be_an Amenity

        # TODO: Find a way to use real recorded data, even if it's a test
        # account.
        #
        # loop through the different properties and floor plans until we
        # find one that has amenities to test.

        # amenities = catch(:amenities) do
        #   client.get_properties.each do |property|
        #     external_property_id = property.external_property_id
        #     floor_plans = client.get_floor_plans(external_property_id)
        #     floor_plans.each do |floor_plan|
        #       floor_plan_name = floor_plan.name
        #       amenities = client.get_floor_plan_amenities(
        #         external_property_id,
        #         floor_plan_name
        #       )

        #       throw :amenities, amenities if amenities.any?
        #     end
        #   end
        #   throw :amenities, []
        # end

        # fail "Unable to find any amenities" if amenities.empty?
        # expect(amenities.first).to be_an Amenity
      end
    end

    describe "#get_unit_amenities" do
      it "returns unit amenities", vcr: {record: :once} do
        # loop through the different properties and floor plans until we
        # find one that has amenities to test.
        amenities = catch(:amenities) do
          client.get_properties.each do |property|
            external_property_id = property.external_property_id
            floor_plans = client.get_floor_plans(external_property_id)
            floor_plans.each do |floor_plan|
              units = client.get_units(external_property_id, floor_plan.name)
              units.each do |unit|
                amenities = client.get_unit_amenities(
                  external_property_id,
                  unit.name,
                )

                throw :amenities, amenities if amenities.any?
              end
            end
          end

          throw :amenities, []
        end

        fail "Unable to find any amenities" if amenities.empty?
        expect(amenities.first).to be_an Amenity
      end
    end

    it "passes the building to the request class" do
      expected_hash = {
        external_property_id: "external_property_id",
        unit_name: "unit_name",
        building: "building",
      }

      response = double

      expect(GetUnitAmenities::Request).to receive(:execute).
        with(hash_including(expected_hash)).
        and_return(response)

      parsed_response = double(amenities: [])

      allow(GetUnitAmenities::Response).to receive(:new).
        with(response).and_return(parsed_response)

      client.get_unit_amenities(
        "external_property_id",
        "unit_name",
        "building",
      )
    end

  end
end
