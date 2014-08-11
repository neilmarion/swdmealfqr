require 'spec_helper'

module YieldStarClient
  describe Client do
    let(:client) do
      described_class.new(CONFIG.merge(
        debug: true,
        logger: Logger.new("tmp/test.log"),
      ))
    end

    describe "#get_units", vcr: {record: :once} do
      it "returns unit information" do
        property = client.get_properties.first
        units = client.get_units(property.external_property_id)
        expect(units.first).to be_a Unit
      end

      it "passes the building to the request class" do
        expected_hash = {
          external_property_id: "external_property_id",
          floor_plan_name: "floor_plan_name",
        }

        response = double

        expect(GetUnits::Request).to receive(:execute).
          with(hash_including(expected_hash)).
          and_return(response)

        parsed_response = double(units: [])

        allow(GetUnits::Response).to receive(:new).
          with(response).and_return(parsed_response)

        client.get_units(
          "external_property_id",
          "floor_plan_name",
        )
      end
    end

    describe "#get_unit" do
      it "returns unit information", vcr: { record: :once } do
        unit = catch(:unit) do
          client.get_properties.each do |property|
            external_property_id = property.external_property_id
            units = client.get_units(external_property_id)
            units.each do |unit|
              u = client.get_unit(external_property_id, unit.name)
              throw :unit, u
            end
          end
          throw :unit, nil
        end

        fail "Could not find a valid unit to test" if unit.nil?
        expect(unit).to be_a Unit
      end
    end
  end
end
