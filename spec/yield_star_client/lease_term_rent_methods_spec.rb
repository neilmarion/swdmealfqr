require 'spec_helper'

module YieldStarClient
  describe Client do

    let(:client) do
      described_class.new(CONFIG.merge(
        debug: true,
        logger: Logger.new("tmp/test.log"),
      ))
    end

    describe "#get_lease_term_rent", vcr: { record: :once } do
      let(:properties) { client.get_properties }
      let(:external_property_id) { properties.last.external_property_id }
      let(:floor_plan) do
        client.get_floor_plans_with_units(external_property_id).find do |floor_plan|
          floor_plan.units.any?
        end
      end
      let(:unit) { floor_plan.units.first }
      let(:unit_2) { floor_plan.units.last }
      let(:date_tomorrow) { Date.today + 1 }

      it "returns the lease term rents" do
        lease_term_rents = client.get_lease_term_rent(
          external_property_id: external_property_id,
          units:
          [
            {
              unit_number: unit.unit_number,
              building: unit.building,
              first_move_in_date: date_tomorrow.to_s,
              last_move_in_date: (date_tomorrow + 45).to_s,
            },
            {
              unit_number: unit_2.unit_number,
              building: unit_2.building,
              first_move_in_date: date_tomorrow.to_s,
              last_move_in_date: (date_tomorrow + 45).to_s,
            }
          ]
        )

        expect(lease_term_rents).to_not be_empty
        expect(lease_term_rents.first).to be_a LeaseTermRent
      end
    end

  end
end
