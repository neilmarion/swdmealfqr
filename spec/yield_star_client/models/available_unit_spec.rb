require 'spec_helper'

module YieldStarClient
  RSpec.describe AvailableUnit do

    describe ".new_from_hash" do
      let(:hash) do
        {
          unit_number: "111"
        }
      end

      it "assigns `unit_number` to `id`" do
        unit = described_class.new_from_hash(hash)

        expect(unit.id).to eq "111"
      end
    end

  end
end
