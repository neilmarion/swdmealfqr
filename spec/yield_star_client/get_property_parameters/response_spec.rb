require "spec_helper"

module YieldStarClient
  module GetPropertyParameters
    describe Response do

      describe "#property_parameters" do
        let(:soap_response) do
          double(
            to_hash: {
              get_property_parameters_response: {
                return: {
                  property: "params"
                }
              }
            }
          )
        end

        let(:property_parameters) { double(PropertyParameters) }
        subject { described_class.new(soap_response).property_parameters }

        before do
          allow(PropertyParameters).to receive(:new_from).
            with(property: "params").
            and_return(property_parameters)
        end

        it { is_expected.to eq property_parameters }
      end

    end
  end

end
