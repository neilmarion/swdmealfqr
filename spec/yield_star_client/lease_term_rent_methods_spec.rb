require 'spec_helper'

module YieldStarClient
  describe Client do

    let(:client) do
      described_class.new(CONFIG.merge(
        debug: true,
        logger: Logger.new("tmp/test.log"),
      ))
    end

    # NOTE: ensure that the units you use have lease term rents set up
    describe "#get_lease_term_rent", vcr: {record: :once} do
      let(:properties) { client.get_properties }
      let(:external_property_id) { properties.last.external_property_id }
      let(:floor_plan) do
        client.get_floor_plans_with_units(external_property_id).find do |floor_plan|
          floor_plan.units.any?
        end
      end
      let(:unit_number) { unit.unit_number }
      let(:unit) { floor_plan.units.first }
      let(:unit_number_2) { unit_2.unit_number }
      let(:unit_2) { floor_plan.units.last }

      it "returns the lease term rents" do
        lease_term_rents = client.get_lease_term_rent(
          external_property_id,
          unit_number,
        )
        expect(lease_term_rents).to_not be_empty
        expect(lease_term_rents.first).to be_a LeaseTermRent
      end

      it_behaves_like "a lease term method" do
        let(:method) { :get_lease_term_rent }
        let(:request_class) { GetLeaseTermRent::Request }
        let(:response_class) { GetLeaseTermRent::Response }
        let(:response_accessor) { :lease_term_rents }
      end

      context "when receiving with a hash parameter" do
        let(:date_tomorrow) { Date.new(2016, 6, 17) }
        # NOTE: use date_tomorrow defined below when recording new
        # cassettes as the lease term dates would've drastically
        # changed since then. Then update date_tomorrow's value
        # above to be the same as (Date.today + 1)
        # let(:date_tomorrow) { Date.today + 1 }
        it "returns lease terms for a single unit" do
          lease_term_rents = client.get_lease_term_rent(
            external_property_id: external_property_id,
            units: {
              # building: 1, # optional, and not needed in current vcr record
              unit_number: unit_number,
              min_lease_term: 1,
              max_lease_term: 18,
              # first_move_in_date: date_tomorrow.to_s,
              # last_move_in_date: (date_tomorrow + 45).to_s,
              ready_for_move_in_date: date_tomorrow,
              unit_available_date: date_tomorrow,
            }
          )

          expect(lease_term_rents).to_not be_empty
          expect(lease_term_rents.first).to be_a LeaseTermRent
          lease_term_rents.each do |lt|
            expect(lt.unit_number).to eq unit_number
            expect(lt.lease_term).to be >= 1
            expect(lt.lease_term).to be <= 18
          end
        end

        it "returns lease terms for multiple units" do
          lease_term_rents = client.get_lease_term_rent(
            external_property_id: external_property_id,
            units: [
              {
                # building: 1, # optional, and not needed in current vcr record
                unit_number: unit_number,
                min_lease_term: 1,
                max_lease_term: 18,
                # first_move_in_date: date_tomorrow.to_s,
                # last_move_in_date: (date_tomorrow + 45).to_s,
                ready_for_move_in_date: date_tomorrow,
                unit_available_date: date_tomorrow,
              },
              {
                unit_number: unit_number_2,
                min_lease_term: 1,
                max_lease_term: 18,
                # first_move_in_date: date_tomorrow.to_s,
                # last_move_in_date: (date_tomorrow + 45).to_s,
                ready_for_move_in_date: date_tomorrow,
                unit_available_date: date_tomorrow,
              }
            ]
          )

          expect(lease_term_rents).to_not be_empty
          expect(lease_term_rents.first).to be_a LeaseTermRent
          lease_term_rents.each do |lt|
            expect([unit_number, unit_number_2]).to include lt.unit_number
            expect(lt.lease_term).to be >= 1
            expect(lt.lease_term).to be <= 18
          end
        end
      end
    end

    describe "#get_lease_term_rent_plus" do
      it "returns the lease term rents", vcr: {record: :once} do
        properties = client.get_properties
        external_property_id = properties.last.external_property_id
        floor_plan = client.get_floor_plans_with_units(external_property_id).first
        unit_number = floor_plan.units.first.unit_number
        lease_term_rents = client.get_lease_term_rent_plus(
          external_property_id,
          unit_number,
        )
        expect(lease_term_rents).to_not be_empty
        expect(lease_term_rents.first).to be_a LeaseTermRent
      end

      it_behaves_like "a lease term method" do
        let(:method) { :get_lease_term_rent_plus }
        let(:request_class) { GetLeaseTermRentPlus::Request }
        let(:response_class) { GetLeaseTermRentPlus::Response }
        let(:response_accessor) { :lease_term_rents }
      end
    end

    describe "#get_renewal_lease_term_rent" do
      it "returns the renewal lease term rents", vcr: {record: :once} do
        # NOTE since we're pulling real data, we have to loop through
        # different properties, floor plans, and units.
        # We test the renewal lease term rents when we find any
        properties = client.get_properties

        renewal_lease_term_rents = catch(:renewal_lease_term_rents) do
          properties.each do |property|
            external_property_id = property.external_property_id
            floor_plans = client.get_floor_plans_with_units(external_property_id)
            floor_plans.each do |floor_plan|
              floor_plan.units.each do |unit|
                unit_number = unit.unit_number
                renewal_lease_term_rents = client.get_renewal_lease_term_rent(
                  external_property_id,
                  unit_number,
                )

                if renewal_lease_term_rents.any?
                  throw :renewal_lease_term_rents, renewal_lease_term_rents
                end
              end
            end
          end
        end

        if renewal_lease_term_rents.empty?
          fail "Could not find a property with available units that have renewal lease term rents to test."
        end

        expect(renewal_lease_term_rents).to_not be_empty
        expect(renewal_lease_term_rents.first).to be_a RenewalLeaseTermRent
      end

      it_behaves_like "a lease term method" do
        let(:method) { :get_renewal_lease_term_rent }
        let(:request_class) { GetRenewalLeaseTermRent::Request }
        let(:response_class) { GetRenewalLeaseTermRent::Response }
        let(:response_accessor) { :renewal_lease_term_rents }
      end
    end

  end
end
