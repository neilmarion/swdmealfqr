module YieldStarClient
  module GetFloorPlans
    class Response < BaseResponse

      def floor_plans
        return @floor_plans if @floor_plans
        @floor_plans = floor_plan_hashes.map do |hash|
          FloorPlan.new(
            external_property_id: hash[:external_property_id],
            name: hash[:name],
            square_feet: hash[:square_footage],
            bedrooms: hash[:bed_rooms],
            bathrooms: hash[:bath_rooms]
          )
        end
      end

      private

      def floor_plan_hashes
        return_data = @soap_response.to_hash[:get_floor_plans_response][:return]

        [return_data[:floor_plan]].flatten.compact
      end

    end
  end
end
