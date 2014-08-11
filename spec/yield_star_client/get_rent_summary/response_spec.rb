require "spec_helper"

module YieldStarClient
  module GetRentSummary
    describe Response do

      describe "#rent_summaries" do
        let(:soap_response) { double(to_hash: response_hash) }
        let(:response_hash) { {} }
        let(:rent_summary_1_hash) do
          { external_property_id: "external_property_id_1" }
        end
        let(:rent_summary_2_hash) do
          { external_property_id: "external_property_id_2" }
        end
        let(:rent_summary_1) { double(RentSummary) }
        let(:rent_summary_2) { double(RentSummary) }
        let(:rent_summary_hashes) do
          [ rent_summary_1_hash, rent_summary_2_hash ]
        end

        it "returns RentSummary objects from the soap response" do
          allow(ExtractRentSummaryHashes).to receive(:execute).
            with(response_hash).
            and_return(rent_summary_hashes)

          allow(RentSummary).to receive(:new).with(rent_summary_1_hash).
            and_return(rent_summary_1)
          allow(RentSummary).to receive(:new).with(rent_summary_2_hash).
            and_return(rent_summary_2)

          rent_summaries = described_class.new(soap_response).rent_summaries

          expect(rent_summaries).to eq [rent_summary_1, rent_summary_2]
        end
      end

    end
  end
end
