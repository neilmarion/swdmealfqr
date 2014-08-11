require "spec_helper"

module YieldStarClient
  module GetUnits
    describe Response do

      describe "#units" do
        let(:soap_response) do
          double(
            to_hash: {
              get_units_response: {
                return: {
                  external_property_id: "external_property_id",
                  floor_plan_name: "floor_plan_name",
                  unit: unit_response,
                }
              }
            }
          )
        end

        subject { described_class.new(soap_response).units }

        context "there are no units" do
          let(:unit_response) { nil }
          it { is_expected.to be_empty }
        end

        context "there is one unit" do
          let(:unit) { double(Unit) }
          let(:unit_attributes) do
            { external_property_id: "external_property_id" }
          end
          let(:unit_response) { unit_attributes }
          before do
            allow(Unit).to receive(:new).with(unit_attributes).
              and_return(unit)
          end
          it { is_expected.to eq [unit] }
        end

        context "there are multiple units" do
          let(:unit_1) { double(Unit) }
          let(:unit_2) { double(Unit) }

          let(:unit_1_attributes) do
            { external_property_id: "external_property_id_1" }
          end

          let(:unit_2_attributes) do
            { external_property_id: "external_property_id_2" }
          end

          let(:units) { [unit_1, unit_2] }
          let(:unit_response) { [unit_1_attributes, unit_2_attributes] }

          before do
            allow(Unit).to receive(:new).with(unit_1_attributes).
              and_return(unit_1)
            allow(Unit).to receive(:new).with(unit_2_attributes).
              and_return(unit_2)
          end
          it { is_expected.to eq units }
        end
      end

    end
  end
end
