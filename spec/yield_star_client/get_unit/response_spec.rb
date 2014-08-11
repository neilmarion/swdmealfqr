require "spec_helper"

module YieldStarClient
  module GetUnit
    describe Response do

      describe "#unit" do
        let(:soap_response) do
          double(
            to_hash: {
              get_unit_response: {
                return: {
                  unit: unit_attributes,
                }
              }
            }
          )
        end

        subject { described_class.new(soap_response).unit }

        let(:unit) { double(Unit) }
        let(:unit_attributes) do
          { external_property_id: "external_property_id" }
        end
        let(:unit_response) { unit_attributes }
        before do
          allow(Unit).to receive(:new).with(unit_attributes).
            and_return(unit)
        end
        it { is_expected.to eq unit }
      end

    end
  end
end
