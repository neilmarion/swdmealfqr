require "spec_helper"

module YieldStarClient
  module GetProperties
    describe Response do

      describe "#properties" do
        let(:soap_response) do
          double(
            to_hash: {
              get_properties_response: {
                return: {
                  property: soap_property_value,
                }
              }
            }
          )
        end

        let(:property_1) { double(Property) }
        let(:property_2) { double(Property) }


        subject { described_class.new(soap_response).properties }

        context "there are multiple properties" do
          before do
            allow(Property).to receive(:new).with(prop: 1).and_return(property_1)
            allow(Property).to receive(:new).with(prop: 2).and_return(property_2)
          end

          let(:soap_property_value) { [{prop: 1}, {prop: 2}] }
          it { is_expected.to eq [property_1, property_2]}
        end

        context "there is a single property" do
          before do
            allow(Property).to receive(:new).with(prop: 1).and_return(property_1)
          end

          let(:soap_property_value) {{ prop: 1 }}
          it { is_expected.to eq [property_1] }
        end

        context "there is no property" do
          let(:soap_property_value) { nil }
          it { is_expected.to be_empty }
        end
      end

    end
  end

end
