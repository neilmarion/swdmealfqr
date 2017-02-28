require "spec_helper"

module YieldStarClient
  module GetRentSummary
    describe Response do

      include Savon::SpecHelper

      let(:fixture) do
        filename = File.join(
          SPEC_DIR,
          "fixtures",
          "get_rent_summary",
          "multiple_summaries.xml",
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

        savon.expects(:get_rent_summary)
          .with(
            message: {
              request: request_params
            }
          )
          .returns(fixture)
      end

      after(:all) { savon.unmock! }

      describe "#rent_summaries_as_floor_plans" do
        it "returns an array of FloorPlan objects" do
          response = described_class.new(
            GetRentSummary::Request.execute(CONFIG)
          )

          sample = response.rent_summaries_as_floor_plans.sample

          expect(sample).to be_a FloorPlan
        end
      end

    end
  end
end
