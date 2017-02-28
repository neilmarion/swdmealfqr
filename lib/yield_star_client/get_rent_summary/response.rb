module YieldStarClient
  module GetRentSummary
    class Response < BaseResponse

      def rent_summaries_as_floor_plans
        return @floorplans if @floorplans

        rent_summary_hashes =
          extract_rent_summary_hashes_from(@soap_response.to_hash)

        @floorplans = rent_summary_hashes.map do |hash|
          FloorPlan.new_from_rent_summary_hash(hash)
        end
      end

      private

      def extract_rent_summary_hashes_from(soap_response)
        ExtractRentSummaryHashes.execute(soap_response)
      end

    end
  end
end
