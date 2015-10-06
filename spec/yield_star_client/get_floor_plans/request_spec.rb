require "spec_helper"

module YieldStarClient
  module GetFloorPlans
    describe Request do

      context "attributes" do
        subject { described_class }

        it { is_expected.to have_attribute(:external_property_id, String) }
      end

      context "validations" do
        subject { described_class.new }

        it { is_expected.to validate_presence_of(:external_property_id) }
        it { is_expected.to validate_length_of(:external_property_id).is_at_most(50) }
      end

      it "has the correct SOAP_ACTION" do
        expect(described_class::SOAP_ACTION).to eq :get_floor_plans
      end

    end
  end
end
