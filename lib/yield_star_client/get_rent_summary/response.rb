module YieldStarClient
  module GetRentSummary
    class Response < BaseResponse

      def rent_summaries
        return @rent_summaries if @rent_summaries
        rent_summary_hashes =
          extract_rent_summary_hashes_from(@soap_response.to_hash)
        @rent_summaries = rent_summary_hashes.map do |hash|
          RentSummary.new_from(hash)
        end
      end

      private

      def extract_rent_summary_hashes_from(soap_response)
        ExtractRentSummaryHashes.execute(soap_response)
      end

    end
  end
end
