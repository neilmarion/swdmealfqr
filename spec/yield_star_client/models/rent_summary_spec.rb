require "spec_helper"

module YieldStarClient
  describe RentSummary do

    context "attributes" do
      subject { described_class }
      it { is_expected.to have_attribute(:effective_date, Date) }
      it { is_expected.to have_attribute(:external_property_id, String) }
      it { is_expected.to have_attribute(:floor_plan_name, String) }
      it { is_expected.to have_attribute(:unit_type, String) }
      it { is_expected.to have_attribute(:bedrooms, Float) }
      it { is_expected.to have_attribute(:bathrooms, Float) }
      it { is_expected.to have_attribute(:avg_square_feet, Integer) }
      it { is_expected.to have_attribute(:min_market_rent, Integer) }
      it { is_expected.to have_attribute(:max_market_rent, Integer) }
      it { is_expected.to have_attribute(:concession_type, String) }
      it { is_expected.to have_attribute(:min_concession, Integer) }
      it { is_expected.to have_attribute(:max_concession, Integer) }
      it { is_expected.to have_attribute(:min_final_rent, Integer) }
      it { is_expected.to have_attribute(:max_final_rent, Integer) }
      it { is_expected.to have_attribute(:floor_plan_description, String) }
    end

    describe ".new_from" do
      it "maps attributes correctly" do
        args = {
          bed_rooms: 2.5,
          bath_rooms: 1,
          avg_sq_ft: 50,
        }

        rs = described_class.new_from(args)
        expect(rs.bedrooms).to eq 2.5
        expect(rs.bathrooms).to eq 1
        expect(rs.avg_square_feet).to eq 50
      end
    end

  end
end
