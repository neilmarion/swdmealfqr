module YieldStarClient
  module GetAvailableUnits
    class Response < BaseResponse

      def available_floor_plans
        return @available_floor_plans if @available_floor_plans
        available_floor_plan_hashes =
          extract_available_floor_plan_hashes_from(@soap_response.to_hash)
        @available_floor_plans = available_floor_plan_hashes.map do |hash|
          FloorPlan.new(
            external_property_id: hash[:external_property_id],
            name: hash[:floor_plan_name],
            square_feet: hash[:sq_ft],
            bedrooms: hash[:bed_rooms],
            bathrooms: hash[:bath_rooms],
            units: hash[:unit],
          )
        end
      end

      private

      def extract_available_floor_plan_hashes_from(soap_response)
        ExtractAvailableFloorPlanHashes.execute(soap_response)
      end

    end
  end
end
