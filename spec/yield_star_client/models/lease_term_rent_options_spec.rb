require "spec_helper"

module YieldStarClient
  describe LeaseTermRentOptions do

    context "attributes" do
      subject { described_class }
      it { is_expected.to have_attribute(:unit_number, String) }
      it { is_expected.to have_attribute(:building, String) }
      it { is_expected.to have_attribute(:min_lease_term, Integer) }
      it { is_expected.to have_attribute(:max_lease_term, Integer) }
      it { is_expected.to have_attribute(:first_move_in_date, Date) }
      it { is_expected.to have_attribute(:last_move_in_date, Date) }
      it { is_expected.to have_attribute(:ready_for_move_in_date, Date) }
      it { is_expected.to have_attribute(:unit_available_date, Date) }
      it { is_expected.to have_attribute(:start_date, Date) }
    end

    describe "#validate!" do
      let(:ltro) { described_class.new }

      context "it is invalid" do
        it "raises argument error" do
          allow(ltro).to receive(:invalid?).and_return(true)
          expect { ltro.validate! }.to raise_error(ArgumentError)
        end
      end

      context "it is valid" do
        it "does not raise error" do
          allow(ltro).to receive(:invalid?).and_return(false)
          expect { ltro.validate! }.to_not raise_error
        end
      end
    end

    context "validations" do
      subject do
        described_class.new(
          unit_number: "unit_number",
          building: "building",
          min_lease_term: 1,
          max_lease_term: 2,
          first_move_in_date: Date.new(2014, 1, 4),
          last_move_in_date: Date.new(2014, 1, 4),
          ready_for_move_in_date: Date.new(2014, 1, 4),
          unit_available_date: Date.new(2014, 1, 4),
          start_date: Date.new(2014, 1, 4),
        )
      end

      it { is_expected.to validate_presence_of(:unit_number) }
      it { is_expected.to ensure_length_of(:building).is_at_most(50) }
    end

    describe "#to_request_hash" do
      let(:lease_term_rent_options) do
        described_class.new(
          unit_number: "unit_number",
          building: nil,
          min_lease_term: 1,
          max_lease_term: 2,
          first_move_in_date: Date.new(2014, 1, 4),
          last_move_in_date: Date.new(2014, 1, 4),
          ready_for_move_in_date: Date.new(2014, 1, 4),
          unit_available_date: Date.new(2014, 1, 4),
          start_date: Date.new(2014, 1, 4),
        )
      end

      subject { lease_term_rent_options.to_request_hash }

      it "returns a hash of the attributes except those with nil values" do
        expect(subject[:unit_number]).to eq "unit_number"
        expect(subject).to_not have_key(:building)
        expect(subject[:min_lease_term]).to eq 1
        expect(subject[:first_move_in_date]).to eq Date.new(2014, 1, 4)
      end
    end

  end
end
