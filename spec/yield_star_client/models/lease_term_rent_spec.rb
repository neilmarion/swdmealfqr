require "spec_helper"

module YieldStarClient
  describe LeaseTermRent do

    it { is_expected.to be_a UnitRate }

    context "attributes" do
      subject { described_class }

      it { is_expected.to have_attribute(:make_ready_date, Date) }
      it { is_expected.to have_attribute(:move_in_date, Date) }
      it do
        is_expected.to have_attribute(:total_concession, Integer).
          with_default(0)
      end
      it do
        is_expected.to have_attribute(:monthly_fixed_concession, Integer).
          with_default(0)
      end
      it do
        is_expected.to have_attribute(:monthly_percent_concession, Float).
          with_default(0.0)
      end
      it do
        is_expected.to have_attribute(:months_concession, Float).
          with_default(0.0)
      end
      it do
        is_expected.to have_attribute(:one_time_fixed_concession, Integer).
          with_default(0)
      end
      it { is_expected.to have_attribute(:price_valid_end_date, Date) }
    end

    describe ".new_from" do
      it "instantiates a LeaseTermRent from the YieldStar hash" do
        lease_term_rent = double
        price_valid_end_date = Date.new(2014, 1, 2)

        allow(described_class).to receive(:new).with(
          price_valid_end_date: price_valid_end_date,
        ).and_return(lease_term_rent)

        resulting_lease_term_rent = described_class.new_from(
          pv_end_date: price_valid_end_date
        )

        expect(resulting_lease_term_rent).to eq lease_term_rent
      end
    end

  end
end
