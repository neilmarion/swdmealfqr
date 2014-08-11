require "spec_helper"

module YieldStarClient
  module GetProperty
    describe Response do

      describe "#property" do
        let(:soap_response) do
          double(
            to_hash: {
              get_property_response: {
                return: {
                  property: {prop: 1},
                }
              }
            }
          )
        end

        let(:property) { double(Property) }
        subject { described_class.new(soap_response).property }

        before do
          allow(Property).to receive(:new).with(prop: 1).and_return(property)
        end

        it { is_expected.to eq property }
      end

    end
  end

end
