require "spec_helper"

module YieldStarClient
  describe UnitRate do

    context "attributes" do
      subject { described_class }
      it { is_expected.to have_attribute(:external_property_id, String) }
      it { is_expected.to have_attribute(:building, String) }
      it { is_expected.to have_attribute(:unit_number, String) }
      it { is_expected.to have_attribute(:lease_term, Integer) }
      it { is_expected.to have_attribute(:end_date, Date) }
      it { is_expected.to have_attribute(:market_rent, Integer) }
      it { is_expected.to have_attribute(:final_rent, Integer) }
      it { is_expected.to have_attribute(:best).with_default(true) }
    end

    describe "#best" do
      context "given 'true'" do
        subject { described_class.new(best: 'true').best }
        it { is_expected.to eq true }
      end
    end

    describe ".new_from" do
      it "is just an alias for .new for subclasses to override" do
        unit_rate = double(described_class)

        expect(described_class).to receive(:new).and_return(unit_rate)
        described_class.new_from({})
      end
    end

  end
end
