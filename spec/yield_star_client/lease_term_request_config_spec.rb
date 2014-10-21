require "spec_helper"

module YieldStarClient
  describe LeaseTermRequestConfig do
    let(:fake_request_class) do
      FakeRequestClass = Class.new(BaseRequest) do
        configure_for_lease_term_rent request_element: :sample_request_element
      end
    end

    context "attributes" do
      subject { fake_request_class }
      it { is_expected.to have_attribute(:external_property_id, String) }
      it { is_expected.to have_attribute(:unit_number, String) }
      it { is_expected.to have_attribute(:building, String) }
      it { is_expected.to have_attribute(:min_lease_term, String) }
      it { is_expected.to have_attribute(:max_lease_term, String) }
      it { is_expected.to have_attribute(:first_move_in_date, Date) }
      it { is_expected.to have_attribute(:last_move_in_date, Date) }
    end

    context "validations" do
      subject { fake_request_class.new }
      it { is_expected.to validate_presence_of(:external_property_id) }
      it { is_expected.to validate_presence_of(:unit_number) }
    end

    it "defines request_args" do
      request = fake_request_class.new(
        unit_number: "unit_number",
        building: "building",
        min_lease_term: "min_lease_term",
        max_lease_term: "max_lease_term",
        first_move_in_date: "first_move_in_date",
        last_move_in_date: "last_move_in_date",
      )

      rent_options = double(
        to_request_hash: { rent_options: "rent_options" }
      )
      allow(LeaseTermRentOptions).to receive(:new).with(
        unit_number: "unit_number",
        building: "building",
        min_lease_term: "min_lease_term",
        max_lease_term: "max_lease_term",
        first_move_in_date: "first_move_in_date",
        last_move_in_date: "last_move_in_date",
      ).and_return(rent_options)

      expected_args = {
        unit_number: "unit_number",
        sample_request_element: {
          rent_options: "rent_options"
        }
      }

      expect(request.request_args).to include(expected_args)
    end
  end
end
