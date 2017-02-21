require "spec_helper"

module YieldStarClient
  module GetAvailableUnits
    describe Response do

      include Savon::SpecHelper

      let(:fixture) do
        filename = File.join(
          SPEC_DIR,
          "fixtures",
          "get_available_units",
          "multiple_floor_plans.xml",
        )
        File.read(filename)
      end
      let(:request_params) do
        {
          :client_name => CONFIG[:client_name],
          :external_property_id => CONFIG[:external_property_id]
        }
      end

      before(:all) do
        savon.mock!

        savon.expects(:get_available_units)
          .with(
            message: {
              request: request_params
            }
          )
          .returns(fixture)
      end

      after(:all) { savon.unmock! }

      describe "#available_units" do
        it "returns an array of AvailableUnit objects" do
          response = described_class.new(
            GetAvailableUnits::Request.execute(CONFIG)
          )

          sample = response.available_units.sample

          expect(sample).to be_an AvailableUnit
        end
      end

    end
  end
end
