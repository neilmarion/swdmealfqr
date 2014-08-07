require "spec_helper"

module YieldStarClient
  describe PropertyParameters do

    context "attributes" do
      subject { described_class }
      it { is_expected.to have_attribute(:external_property_id, String) }
      it { is_expected.to have_attribute(:post_date, Date) }
      it { is_expected.to have_attribute(:min_new_lease_term, Integer) }
      it { is_expected.to have_attribute(:max_new_lease_term, Integer) }
      it { is_expected.to have_attribute(:new_lease_term_options, Integer) }
      it { is_expected.to have_attribute(:max_move_in_days, Integer) }
      it { is_expected.to have_attribute(:min_renewal_lease_term, Integer) }
      it { is_expected.to have_attribute(:max_renewal_lease_term, Integer) }
    end

    describe ".new_from" do
      context "no parameter key" do
        let(:raw_hash) { {external_property_id: "external_property_id"} }

        it "instantiates a PropertyParameters object from the hash" do
          property_parameters = double
          expect(described_class).to receive(:new).with(
            external_property_id: "external_property_id"
          ).and_return(property_parameters)
          expect(described_class.new_from(raw_hash)).to eq property_parameters
        end
      end

      context "multiple parameters" do
        let(:raw_hash) do
          {
            external_property_id: "external_property_id",
            parameter: [
              {
                name: "Maximum Renewal Lease Term",
                value: "15",
              },
              {
                name: "Minimum New Lease Term",
                value: "1",
              },
            ]
          }
        end

        it "instantiates a PropertyParameters object from the hash" do
          property_parameters = double
          expect(described_class).to receive(:new).with(
            external_property_id: "external_property_id",
            max_renewal_lease_term: "15",
            min_new_lease_term: "1",
          ).and_return(property_parameters)
          expect(described_class.new_from(raw_hash)).to eq property_parameters
        end
      end

      context "single parameter" do
        let(:raw_hash) do
          {
            external_property_id: "external_property_id",
            parameter: {
              name: "Maximum Renewal Lease Term",
              value: "15",
            }
          }
        end

        it "instantiates a PropertyParameters object from the hash" do
          property_parameters = double
          expect(described_class).to receive(:new).with(
            external_property_id: "external_property_id",
            max_renewal_lease_term: "15",
          ).and_return(property_parameters)
          expect(described_class.new_from(raw_hash)).to eq property_parameters
        end
      end
    end

  end
end
