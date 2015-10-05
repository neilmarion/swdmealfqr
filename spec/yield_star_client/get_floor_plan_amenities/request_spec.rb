require "spec_helper"

module YieldStarClient
  module GetFloorPlanAmenities
    describe Request do

      context "attributes" do
        subject { described_class }

        it { is_expected.to have_attribute(:external_property_id, String) }
        it { is_expected.to have_attribute(:floor_plan_name, String) }
      end

      context "validations" do
        subject { described_class.new }

        it { is_expected.to validate_presence_of(:external_property_id) }
        it { is_expected.to validate_length_of(:external_property_id).is_at_most(50) }
        it { is_expected.to validate_presence_of(:floor_plan_name) }
      end

      it "has the correct SOAP_ACTION" do
        expect(described_class::SOAP_ACTION).to eq :get_floor_plan_amenities
      end

    end
  end
end
