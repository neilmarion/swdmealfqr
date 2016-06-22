require 'spec_helper'

module YieldStarClient
  describe Client do

    include Savon::SpecHelper

    let(:logger) { Logger.new("tmp/test.log") }
    let(:client_config) do
      CONFIG.merge(
        debug: true,
        logger: logger,
      )
    end

    let(:client) { described_class.new(client_config) }

    describe "#get_rent_summary" do
      it "returns the rent summaries", vcr: {record: :once} do
        rent_summaries = catch(:rent_summaries) do
          client.get_properties.each do |property|
            external_property_id = property.external_property_id
            rent_summaries = client.get_rent_summary(external_property_id)
            throw :rent_summaries, rent_summaries if rent_summaries.any?
          end
          throw :rent_summaries, [] if rent_summaries.empty?
        end

        fail "Unable to find rent summaries" if rent_summaries.empty?
        expect(rent_summaries.first).to be_a RentSummary
      end
    end
  end
end
