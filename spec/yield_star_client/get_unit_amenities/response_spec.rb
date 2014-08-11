require "spec_helper"

module YieldStarClient
  module GetUnitAmenities
    describe Response do

      describe "#amenities" do
        let(:soap_response) do
          double(
            to_hash: {
              get_unit_amenities_response: {
                return: {
                  external_property_id: "external_property_id",
                  unit_name: "unit_name",
                  amenity: amenity_response,
                }
              }
            }
          )
        end

        subject { described_class.new(soap_response).amenities }

        context "there are no amenities" do
          let(:amenity_response) { nil }
          it { is_expected.to be_empty }
        end

        context "there is one amenity" do
          let(:amenity) { double(Amenity) }
          let(:amenity_attributes) do
            { name: "Rent Adjustment", type: "Fixed", value: 50.0 }
          end
          let(:amenity_response) { amenity_attributes }
          before do
            allow(Amenity).to receive(:new).with(amenity_attributes).
              and_return(amenity)
          end
          it { is_expected.to eq [amenity] }
        end

        context "there are multiple amenities" do
          let(:amenity_1) { double(Amenity) }
          let(:amenity_2) { double(Amenity) }

          let(:amenity_1_attributes) do
            { name: "Rent Adjustment", type: "Fixed", value: 50.0 }
          end

          let(:amenity_2_attributes) do
            { name: "Rent Adjustment", type: "Fixed", value: 60.0 }
          end

          let(:amenities) { [amenity_1, amenity_2] }
          let(:amenity_response) { [amenity_1_attributes, amenity_2_attributes] }

          before do
            allow(Amenity).to receive(:new).with(amenity_1_attributes).
              and_return(amenity_1)
            allow(Amenity).to receive(:new).with(amenity_2_attributes).
              and_return(amenity_2)
          end
          it { is_expected.to eq amenities }
        end
      end

    end
  end
end
