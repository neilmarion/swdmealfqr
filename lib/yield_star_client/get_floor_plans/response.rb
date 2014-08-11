module YieldStarClient
  module GetFloorPlans
    class Response < BaseResponse

      def floor_plans
        return @floor_plans if @floor_plans
        return_data = @soap_response.to_hash[:get_floor_plans_response][:return]
        floor_plan_hashes = [return_data[:floor_plan]].flatten.compact
        @floor_plans = floor_plan_hashes.map { |hash| FloorPlan.new(hash) }
      end

    end
  end
end
