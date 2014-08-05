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

  end
end
