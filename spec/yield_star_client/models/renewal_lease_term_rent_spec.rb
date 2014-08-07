require "spec_helper"

module YieldStarClient
  describe RenewalLeaseTermRent do

    it { is_expected.to be_a UnitRate }

    context "attributes" do
      subject { described_class }
      it { is_expected.to have_attribute(:start_date, Date) }
    end

  end
end
