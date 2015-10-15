require 'spec_helper'

module YieldStarClient
  RSpec.describe AvailableUnit do

    describe "#id" do
      let(:unit) do
        build(:yield_star_client_available_unit, {
          building: "22",
          unit_type: "2br",
          unit_number: "101",
        })
      end

      it "is a hash of the building, unit type, unit number" do
        expect(unit.id).to eq Digest::SHA1.hexdigest "22-2br-101"
      end
    end

  end
end
